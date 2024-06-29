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
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Image(.libraryLogo)
                .resizable()
                .frame(width: 250, height: 200)
                .scaledToFit()

            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
                .textContentType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textContentType(.newPassword)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textContentType(.newPassword)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    private func signUp() {
        // Check if required fields are empty
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "All fields are mandatory"
            isShowingAlert = true
            return
        }

        // Check if passwords match
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

      
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                
                isPresented = false
                alertMessage = "Account created successfully"
                email = ""
                password = ""
                confirmPassword = ""
                
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(isPresented: .constant(true))
    }
}
