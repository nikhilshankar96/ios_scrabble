//
//  GameState.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import Foundation

struct GameState {
    var user1, user2: UserState
    var link: String
    var board: [[String]]
}

struct UserState {
    var score: Int
    var reserveLeft: Int // num of pieces yet to draw
    var inHand: [String]
}
