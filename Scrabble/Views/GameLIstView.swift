//
//  GameLIstView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/30/21.
//

import SwiftUI

struct GameListView: View {
    @ObservedObject private var viewModel = GameListViewModel()
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
      NavigationView {
        List(viewModel.games) { game in
            NavigationLink(destination: GameView()){
                VStack(alignment: .leading) {
                Text("\(game.id)")
                  .font(.headline)
                Text("\( game.turn == session.session?.email ? "Your" : "\(game.turn)'s" ) turn")
                  .font(.subheadline)
                }
            }
//            .simultaneousGesture(TapGesture().onEnded {
//                print(game.id)
//            })
        }
        .environmentObject(session)
        .navigationBarTitle("Your Games")
        .onAppear(){
                self.viewModel.fetchUserGameList(session: session)
        }
      }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
    }
}
