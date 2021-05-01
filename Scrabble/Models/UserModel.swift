//
//  UserModel.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/30/21.
//

import Foundation

struct UserModel: Codable {
    var id: String?
    var score: Int?
    var reserveCount: Int?
    var pieceSet: [String]?
}
