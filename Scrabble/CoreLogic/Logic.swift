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
    
    static let row = Array(repeating: " ",count: gridSize);
    
    static let emptyBoard = [
        0: row,
        1: row,
        2: row,
        3: row,
        4: row,
        5: row,
        6: row,
        7: row,
        8: row,
        9: row,
        10: row,
        11: row,
        12: row,
        13: row,
        14: row
        ]
    
    static let scoreMap:[String:Int] = [
        "": 0,
        " ": 0,
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

    static func getNewCharacter() -> String{
        var charPool = [String]();
        alphabet.forEach({ charPool.append(contentsOf: Array(repeating: $0,
                    count:( 14 - scoreMap[$0]!)*(11 - scoreMap[$0]!)
        ) )});
        charPool.shuffle();
        let r = charPool[Int.random(in: 0..<charPool.count-1)];
        
        return r
    }
    
    static func getNewSet() -> [String]{
        return [getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter(), getNewCharacter()]
    }
    
    static func calcWordScore(word: String) -> Int{
         var score = 0;
         let arr = word.uppercased().map { String($0) }
         for a in arr {
             score += (scoreMap[a]!)
         }
         return score;
     }
    
    static func onlyOneUpdated(_ updated: [[Int]]) -> BoardLocator{
        var rFlag = true
        var cFlag = true
        let r = updated[0][0]
        let c = updated[0][1]
        var rArr = [updated[0][0]]
        var cArr = [updated[0][1]]
        
        for n in updated{
            if n[0] != r {
                rFlag = false
                rArr.append(n[0])
            }
            if n[1] != c {
                cFlag = false
                cArr.append(n[1])
            }
        }
        if(rFlag){
            return BoardLocator(flag: rFlag, axis: "R", loc: r, arr: cArr.sorted())
        }
        if(cFlag){
            return BoardLocator(flag: cFlag, axis: "C", loc: c, arr: rArr.sorted())
        }
        
        return BoardLocator(flag: false, axis: "", loc: -1, arr: [])
    }
    
    static func isContiguous(_ grid: [Int: [String]]) -> Bool {
        var result = 0
//        var notGrid = grid.map({ $0.map({ $0 == " " ? "0" : "1" }) })
        var notGrid = grid
        
        for row in 0...14 {
            for column in 0...14 {
                if notGrid[row]?[column] != " " {
                    result += 1
                    islandSearchDFS(&notGrid, row, column)
                }
            }
        }
        return result == 1
    }
    
    static func islandSearchDFS(_ grid: inout [Int: [String]],_ row: Int, _ column: Int) {
        if row < 0 || row >= 15 || column < 0 || column >= 15 || grid[row]![column] == " " {
            return
        } // 1
        grid[row]![column] = " " // visited island //2
        islandSearchDFS(&grid, row-1, column)  //3
        islandSearchDFS(&grid, row+1, column) //3
        islandSearchDFS(&grid, row, column-1) //3
        islandSearchDFS(&grid, row, column+1) //3
    }

    static func transpose(_ input: [Int: [String]]) -> [Int: [String]] {
        var result = self.emptyBoard;
     for i in 0...14{
         for j in 0...14{
             result[j]?[i] = (input[i]?[j])!
         }
     }
     return result
    }
    
    
    static func checkBoardValidity(_ board: [Int: [String]]) -> Bool{
//        print("Board validity check!")
        var flag = true
        for i in 0...14 {
            let row = board[i]!
            
            let s = row.joined(separator: "").trimmingCharacters(in: .whitespaces)
            if(s == "" || s.count < 2){
                continue
            }
            s.split(separator: " ").forEach({
                if $0.count > 1 {
                    if !Words.checkIfWord($0.lowercased()){
                    flag = false
                    }
                }
            })
        }
        if(!flag){
//            print("Board validity check end in row -> \(flag)")
            return flag
        }
        
        let transpose = transpose(board)
        
        for c in 0...14  {
            let col = transpose[c]!
            let s = col.joined(separator: "").trimmingCharacters(in: .whitespaces)
            if(s == "" || s.count < 2){
                continue
            }
//            print("->",s)
            s.split(separator: " ").forEach({
//                print("word: \($0)")
                if $0.count > 1 {
                    if !Words.checkIfWord($0.lowercased()){
                    flag = false
                    }
                }
            })
        }
        
//        print("Board validity check end -> \(flag)")
        return flag
    }
    
    static func checkIfWordAndBoard(board: [Int: [String]], updatedCoords: [[Int]]) -> Bool{
        let locator: BoardLocator = onlyOneUpdated(updatedCoords)
        if !(isContiguous(board) && locator.flag) {
            return false
        }
        
//        print("Locator: ", locator)
        var currentWord = ""
        var i = locator.arr[0]
        if locator.axis == "R" {
            while board[locator.loc]![i-1] != " "  && i > 0 {
                i -= 1
            }
            while board[locator.loc]![i] != " "  && i < 14 {
                currentWord.append(board[locator.loc]![i])
                i += 1;
            }
            
        } else if locator.axis == "C" {
            while board[i-1]![locator.loc] != " " && i > 0{
                i -= 1
            }
            while board[i]![locator.loc] != " " && i < 14{
                currentWord.append(board[i]![locator.loc])
                i += 1;
            }
        }
       
        return Words.checkIfWord(currentWord.lowercased()) && checkBoardValidity(board);
    }
    
    
    static func generateNewGame(player: String, otherPlayer: String) -> GameModel {
        
        let uuid = UUID().uuidString
        
        var u1 = UserModel(id: player, score: 0, reserveCount: 10, pieceSet: Logic.getNewSet())
        
        var u2 = UserModel(id: otherPlayer, score: 0, reserveCount: 10, pieceSet: Logic.getNewSet())
        
        var game = GameModel(id: uuid, user1: u1, user2: u2, board: Logic.emptyBoard, turn: u1.id!, gameOver: false)
        
        return game
    }
}

struct BoardLocator {
    var flag: Bool
    var axis: String
    var loc: Int
    var arr: [Int]
}
