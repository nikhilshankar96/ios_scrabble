//
//  GameListViewModel.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/30/21.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class GameListViewModel: ObservableObject {
    @Published var games = [GameModel]()
    @Published var currentGame: GameModelClass?
    
    private var db = Firestore.firestore()

    func fetchUserGameList(session: SessionStore){
        let uid = (session.session?.uid)!
        db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                let str = data["games"] as! [String]
                print(str)
                str.forEach({self.fetchGame(game: $0)})
            }
    }
    
    
    func fetchGame(game: String) {
        db.collection("games").document(game)
            .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let g = try! FirestoreDecoder().decode(GameModel.self, from: document.data()!)
                self.games = self.games.filter({ $0.id != g.id})
                self.games.append(g)
                print(g)
            }
    }
}
