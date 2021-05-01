//
//  SignUpView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/29/21.
//

import SwiftUI

struct SignUpView : View {

    @State var email: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var loading = false
    @State var error = false
    
    @State var toastText = ""
    @State var showToast: Bool = false

    @EnvironmentObject var session: SessionStore

    func signUp () {
        
        if User.isValidEmail(testStr: email) {
           
            if(self.password == self.password2){
                loading = true
                error = false
                session.signUp(email: email, password: password) { (result, error) in
                    self.loading = false
                    if error != nil {
                        self.error = true
                        toastText = "Unavailable!"
                        showToast = true
                    } else {
                        self.email = ""
                        self.password = ""
                    }
                }
            } else {
                self.error = true
                toastText = "Passwords dont match!"
                showToast = true
            }
        
        } else {
            self.error = true
            toastText = "Weird email!"
            showToast = true
        }
    }
   

    var body: some View {
        
        VStack(spacing: 10){
        
            Spacer();
                
            Text("Create an account")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.9))
            
            VStack(spacing: 30){
                TextField("Email", text: $email, onCommit: {
                    self.hideKeyboard()
                }).autocapitalization(.none)
                    .font(.system(size: 16))
                    .padding(20)
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(error ? Color.red : Color.blue, lineWidth: 1)
                    )
                
                SecureField("Password", text: $password){
                    self.hideKeyboard()
                }
                    .font(.system(size: 16))
                    .padding(20)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(error ? Color.red : Color.blue, lineWidth: 1)
                    )
                
                SecureField("Password confirm", text: $password2){
                    self.hideKeyboard()
                    self.signUp()
                }
                    .font(.system(size: 16))
                    .padding(20)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(error ? Color.red : Color.blue, lineWidth: 1)
                    )
                    
                
                Button(action: signUp) {
                    Text("Sign Up!")
                }
                .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color(red: 0.3, green: 0.9, blue: 0.9))
                .foregroundColor(.black)
                .clipShape(Capsule())
                
                
            }.padding(30)
            Spacer();
        }
        .toast(isShowing: $showToast, text: Text(toastText))
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color.black).ignoresSafeArea(.all)
        .onTapGesture {
                    self.hideKeyboard()
                }
    }
}
