//
//  MainView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/29/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var session: SessionStore
    
    func getUser () {
         session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                TabView {
                    GameView()
                        .tabItem {
                            Label("Game", systemImage: "gamecontroller.fill")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                }
            } else {
                SignInView()
            }
        }.onAppear(perform: getUser)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SessionStore())
    }
}
