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
        print("temp")
        session.createNewGame(player: "7Ap17j8jd3SXILY84mPxKk3PnzZ2", otherPlayer: "LpNf77uamXfCW4LzxvGdW5vVAcS2")
    }
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            
            Text("Hello \((session.session?.email ?? "" ))").foregroundColor(Color.white)
        
            Spacer()
            
            Button(action:{
                temp()
            }) {
                Text("New Game")
            }
            .frame(width: 100, height: 30, alignment: .center)
            .padding(30)
            .background(Color(red: 0.2, green: 0.8, blue: 0.8))
            .foregroundColor(.black)
            .clipShape(Capsule())
            
            Spacer()
            
            Button(action: signOut) {
                Text("Sign out")
            }
            .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(30)
            .background(Color(red: 0.8, green: 0.2, blue: 0.3))
            .foregroundColor(.black)
            .clipShape(Capsule())
            
            Spacer()
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
