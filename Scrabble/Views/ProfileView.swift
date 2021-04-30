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
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: signOut) {
                Text("Sign out")
            }
            .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color(red: 0.3, green: 0.9, blue: 0.9))
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
