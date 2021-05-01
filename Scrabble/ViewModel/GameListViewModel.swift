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
    private var db = Firestore.firestore()

    func fetchUserGameList(session: SessionStore){
        let uid = session.session?.uid
        fetchGame(game: "testGame2")
    }
    
    
    func fetchGame(game: String){
     print(game)
        Firestore.firestore().collection("games").document(game).getDocument { document, error in
            if let document = document {
                let model = try! FirestoreDecoder().decode(GameModel.self, from: document.data()!)
                print("Model: \(model)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
