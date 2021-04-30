//
//  User.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/28/21.
//

import Foundation

class User {
    var uid: String
    var email: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }

}
