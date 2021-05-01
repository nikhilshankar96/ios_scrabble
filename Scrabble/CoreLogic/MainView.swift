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
                TabView() {
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }.tag(0)
                    
                    GameListView()
                        .tabItem {
                            Label("Games", systemImage: "list.star")
                        }.tag(1)
                    
                    GameView()
                        .tabItem {
                            Label("Game", systemImage: "gamecontroller.fill")
                        }.tag(2)
                    
                }.accentColor(Color(red: 0.2, green: 0.9, blue: 0.9))
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
