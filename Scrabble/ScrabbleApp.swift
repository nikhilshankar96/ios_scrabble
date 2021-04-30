//
//  ScrabbleApp.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import SwiftUI
import Firebase

@main
struct ScrabbleApp: App {
    @StateObject private var session = SessionStore()
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(SessionStore())
        }
    }
}
