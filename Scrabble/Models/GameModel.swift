//
//  GameModel.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/30/21.
//

import Foundation

struct GameModel: Identifiable, Codable {
    var id: String
    var user1, user2: UserModel
    var board: [Int: [String]]
    var turn: String
    var gameOver: Bool
}


//let testData = [
//    GameModel(user1: "nikhil-shankar@outlook.com", user2: "nikhilshankarusa@gmail.com", turn: "nikhil-shankar@outlook.com", gameOver: false, boardHistory: []),
//    GameModel(user1: "random@outlook.com", user2: "random@gmail.com", turn: "random@outlook.com", gameOver: false, boardHistory: [])
//]
