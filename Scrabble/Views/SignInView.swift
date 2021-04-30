//
//  SignInView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/29/21.
//

import SwiftUI

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    
    @State var toastText = ""
    @State var showToast: Bool = false

    @EnvironmentObject var session: SessionStore

    func signIn () {
        loading = true
        error = false
        
        if User.isValidEmail(testStr: email) {
            session.signIn(email: email, password: password) { (result, error) in
                self.loading = false
                if error != nil {
                    self.error = true
                    toastText = "Who are you?"
                    showToast = true
                } else {
                    self.email = ""
                    self.password = ""
                }
            }
        } else {
            self.error = true
            toastText = "Weird email!"
            showToast = true
        }
    }
   

    var body: some View {
        
        NavigationView{
            VStack(spacing: 10){
            
                Spacer();
                    
                Text("Welcome back my friend!")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.9))
                
                VStack(spacing: 30){
                    TextField("Email", text: $email, onCommit: {
                        self.hideKeyboard()
                    })
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
                        self.signIn()
                    }
                        .font(.system(size: 16))
                        .padding(20)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(error ? Color.red : Color.blue, lineWidth: 1)
                        )
                        
                    
                    Button(action: signIn) {
                        Text("Sign in")
                    }
                    .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color(red: 0.3, green: 0.9, blue: 0.9))
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                    
                    
                }.padding(30)
                
                Spacer();
                
                    NavigationLink(destination: SignUpView()){
                        HStack{
                            Text("Not a user? ")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Register!")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.9))
                    }
                
                    }.padding(.vertical, 40)
                
    //            Spacer();
            }
            .toast(isShowing: $showToast, text: Text(toastText))
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(Color.black).ignoresSafeArea(.all)
            .onTapGesture {
                        self.hideKeyboard()
                    }
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
