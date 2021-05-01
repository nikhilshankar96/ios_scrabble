//
//  GameState.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import Foundation

class Game {
    public static var gameState: GameState?
    public static var thisUser: UserState?

    static func newGame() -> GameState{
        print("new GameState")
        gameState = GameState(
            user1: UserState(score: 0, reserveCount: 10, pieceSet: ["N","I","K","H","I","L","G","O","D"], isMyTurn: true),
            user2: UserState(score: 0, reserveCount: 10, pieceSet: Logic.getNewSet(), isMyTurn: false),
            board: Logic.emptryBoard,
            whosTurn: 0,
            gameOver: false,
            boardHistory: [])
        return gameState!
    }

    static func getGameState() -> GameState{
        print("getting GameState")
        if(gameState == nil){
            return newGame();
        }
        return gameState!
    }

    static func getThisUserState() -> UserState{
        if(thisUser == nil){
            thisUser = gameState?.user1
        }
        return thisUser!
    }
}

struct GameState {
    var user1, user2: UserState
    var board: [Int: [String]]
    var whosTurn: Int
    var gameOver: Bool
}

struct UserState {
    var score: Int
    var reserveCount: Int
    var pieceSet: [String]
    var isMyTurn: Bool
}
