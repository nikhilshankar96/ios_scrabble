//
//  GameConstants.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import Foundation

// ## To do list ##

// check if new placement is a word in all possible directions
// check if new placed characters are all in one row/col

// ## ##

class GameConstants{
    static let gridSize = 15;
    static let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    static var matrix = Array(repeating: Array(repeating: "",count: gridSize), count: gridSize)
    static let scoreMap:[String:Int] = [
        "": 0,
        "A": 1,
        "B": 3,
        "C": 3,
        "D": 2,
        "E": 1,
        "F": 4,
        "G": 2,
        "H": 4,
        "I": 1,
        "J": 8,
        "K": 5,
        "L": 1,
        "M": 3,
        "N": 3,
        "O": 1,
        "P": 3,
        "Q": 10,
        "R": 1,
        "S": 1,
        "T": 1,
        "U": 1,
        "V": 4,
        "W": 4,
        "X": 8,
        "Y": 4,
        "Z": 10
    ]
//    Scores
//    0 Points - Blank tile.
//    1 Point - A, E, I, L, N, O, R, S, T and U.
//    2 Points - D and G.
//    3 Points - B, C, M and P.
//    4 Points - F, H, V, W and Y.
//    5 Points - K.
//    8 Points - J and X.
//    10 Points - Q and Z.
    
    static func getNewCharacter() -> String{
        var charPool = [String]();
        alphabet.map({ charPool.append(contentsOf: Array(repeating: $0,count:( 13 - scoreMap[$0]!)) )})
        charPool.shuffle()
        let r = charPool[Int.random(in: 0..<charPool.count-1)]
        print("random: \(r)")
        return r
    }
    
    static func calcWordScore(word: String) -> Int{
        var score = 0;
        let arr = word.uppercased().map { String($0) }
        for a in arr {
            score += (scoreMap[a]!)
        }
        print(word, score)
        return score;
    }
    
    static func getNewSet() -> [String]{
        return [getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter()]
    }
}
