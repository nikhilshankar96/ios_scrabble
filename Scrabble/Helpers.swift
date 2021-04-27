//
//  Helpers.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import Foundation

class Helpers{
    
//    static var isFirstTime = false;
    
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
