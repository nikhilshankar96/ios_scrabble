//
//  SessionStore.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/29/21.
//

import Foundation
import SwiftUI
import Firebase
import Combine
import CodableFirebase

class SessionStore : ObservableObject {
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {
        didSet {self.didChange.send(self)}
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(
                    uid: user.uid,
                    email: user.email
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        
        Firestore.firestore().collection("users").document(email).setData(["games": []])
    }

    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
    func updateGame(game: GameModel){
        print("Game update:\n")
        let docData = try! FirestoreEncoder().encode(game)
        Firestore.firestore().collection("games").document(game.id).setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func createNewGame(player: String, otherPlayer: String){
        print("New game:\n")
        var game = Logic.generateNewGame(player: player, otherPlayer: otherPlayer)
        self.updateGame(game: game)
        let db = Firestore.firestore()
        
        var p1List = [String]();
        var p2List = [String]();
        
        p1List.append(game.id)
        p2List.append(game.id)
        
        db.collection("users").document(player).getDocument{ documentSnapshot, error in
            
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
            p1List.append(contentsOf: data["games"] as! [String])
               
            }
        
        
        db.collection("users").document(otherPlayer).getDocument{ documentSnapshot, error in
            
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
            p2List.append(contentsOf: data["games"] as! [String])
            }
        
        
        Firestore.firestore().collection("users").document(player).setData(["games": p1List]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
        Firestore.firestore().collection("users").document(otherPlayer).setData(["games": p2List]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
        print(p1List, p2List)
        
        
    }
    
    func getAllUsers() -> [String]{
        var list = [String]();
        
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                    list.append(document.documentID)
                }
            }
        }
        print(list)
        return list
    }
}
