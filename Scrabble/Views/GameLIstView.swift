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
    VStack(alignment: .center, spacing: 15){
        
        NavigationView {
        List(viewModel.games) { game in
            NavigationLink( destination: GameView(game: game, player: game.user1.id == session.session?.uid ? game.user1 : game.user2 )){
                VStack(alignment: .leading) {
                Text("\(game.id)")
                  .font(.headline)
                Text("\( game.turn == session.session?.uid ? "Your" : "\(game.turn)'s" ) turn")
                  .font(.subheadline)
                }
            }
        }
        .environmentObject(session)
        .navigationBarTitle("Your Games")
        .onAppear(){
                self.viewModel.fetchUserGameList(session: session)
        }
      }
        
    }
    .frame(maxWidth:.infinity,maxHeight: .infinity)
    .background(Color.black).ignoresSafeArea(.all)
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
    }
}
