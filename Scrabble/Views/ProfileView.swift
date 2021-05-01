//
//  ProfileView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/29/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var error = false
    @State var toastText = ""
    @State var showToast: Bool = false
    
    func signOut () {
        if(!session.signOut()){
            self.error = true
            toastText = "Error!"
            self.showToast = true
        } else {
            print("Signed out!")
        }
    }
    
    func temp(){
        print("TEMP")
        // Add a new document with a generated ID
        var u1 = UserModel(id: "7Ap17j8jd3SXILY84mPxKk3PnzZ2", score: 0, reserveCount: 10, pieceSet: Logic.getNewSet())
        
        var u2 = UserModel(id: "LpNf77uamXfCW4LzxvGdW5vVAcS2", score: 0, reserveCount: 10, pieceSet: Logic.getNewSet())
        
        var game = GameModel(id: "testGame2", user1: u1, user2: u2, board: Logic.emptryBoard, turn: u1.id!, gameOver: false)
        
        session.addGame(game: game)


        // Decode
//        let jsonDecoder = JSONDecoder()
//        let secondDog = try! jsonDecoder.decode(GameModel.self, from: jsonData)

        
        
        print("TEMP /")

    }
    
    var body: some View {
        VStack(alignment: .center){
            Text("Hello \((session.session?.email)!)")
            
            Button(action: signOut) {
                Text("Sign out")
            }
            .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(30)
            .background(Color(red: 0.8, green: 0.2, blue: 0.3))
            .foregroundColor(.black)
            .clipShape(Capsule())
            
            Button(action: temp) {
                Text("TEMP")
            }
            .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(30)
            .background(Color(red: 0.2, green: 0.8, blue: 0.8))
            .foregroundColor(.black)
            .clipShape(Capsule())
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color.black).ignoresSafeArea(.all)
        .toast(isShowing: $showToast, text: Text(toastText))
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
