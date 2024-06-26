//
//  LoginView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var isClicked: Bool = false
    
    var body: some View {
        VStack {
            
            
            Image(.libraryLogo).resizable().frame(width:250, height:200)
               .scaledToFit()
            Text("Login").font(.largeTitle)
                .padding()
            TextField("Enter your Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Enter Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                
                isLoggedIn = true
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            
            
            NavigationLink(destination: RegistrationView(isPresented: $isClicked)) {
                Text("New to application Sign Up")
            }
            .padding()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}

