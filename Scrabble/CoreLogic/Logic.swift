//
//  Logic.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/28/21.
//

import Foundation

class Logic {
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
        alphabet.map({ charPool.append(contentsOf: Array(repeating: $0,
                    count:( 14 - scoreMap[$0]!)*(11 - scoreMap[$0]!)
        ) )})
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
    
    static func isContiguous(_ grid: [[String]]) -> Bool {
//        if(!isFirstTime){
//            isFirstTime = true
//            return true
//        }
        var result = 0
        var notGrid = grid.map({ $0.map({ $0 == "" ? "0" : "1" }) })
        for row in 0..<grid.count {
            for column in 0..<notGrid[row].count {
                if notGrid[row][column] == "1" {
                    result += 1
                    islandSearchDFS(&notGrid, row, column)
                }
            }
        }
        return result == 1
    }

    static func islandSearchDFS(_ grid: inout [[String]],_ row: Int, _ column: Int) {
        if row < 0 || row>=grid.count || column < 0 || column>=grid[row].count || grid[row][column] == "0" {
            return
        } // 1
        grid[row][column] = "0" // visited island //2
 
        islandSearchDFS(&grid, row-1, column)  //3
        islandSearchDFS(&grid, row+1, column) //3
        islandSearchDFS(&grid, row, column-1) //3
        islandSearchDFS(&grid, row, column+1) //3
    }
}
