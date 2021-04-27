//
//  GameConstants.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import Foundation

class GameConstants{
    static let gridSize = 15;
    static let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    static var matrix = Array(repeating: Array(repeating: "", count: gridSize), count: gridSize)
}
