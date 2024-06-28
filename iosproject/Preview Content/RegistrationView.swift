//
//  RegistrationView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var alertMessage = " "
    @State private var isShowingalert = false
    @State var isPresented: Bool
    
    var body: some View {
        VStack {
            
            Image(.libraryLogo).resizable().frame(width:250, height:200)
               .scaledToFit()
            Text("SignUp")
                .font(.largeTitle)
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                SignUp()
            }) {
                Text("Sign Up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    
//    private func register() {
//        guard password == confirmPassword else {
//            errorMessage = "Passwords do not match"
//            return
//        }
//        
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                alertMessage=error.localizedDescription
//                isShowingalert = true
//            }
//            
//            
//            else{
//                
//                isPresented = false
//            }
//        }
//    }
    
    private func SignUp(){
      
        Auth.auth().createUser(withEmail: email, password: password){
            authResult, error in
            if let error = error{
                
                alertMessage=error.localizedDescription
                isShowingalert = true
                
            }else{
                
                isPresented = false
            }
            
            
        }
    }
}

 

#Preview {
    RegistrationView(isPresented: true)
}



//private func SignUp(){
//  
//    Auth.auth().createUser(withEmail: email, password: password){
//        authResult, error in
//        if let error = error{
//            
//            alertMessage=error.localizedDescription
//            isShowingalert = true
//            
//        }else{
//            
//            isPresented = false
//        }
//        
//        
//    }
//}
