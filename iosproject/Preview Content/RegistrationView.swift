import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedRole = "User"
    @State private var errorMessage = ""
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    @Binding var isPresented: Bool

    let roles = ["User", "Admin"]

    var body: some View {
        VStack {
            Image("library_logo")
                .resizable()
                .frame(width:150, height: 150)
                .scaledToFit()

            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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

            Picker("Role", selection: $selectedRole) {
                ForEach(roles, id: \.self) { role in
                    Text(role)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

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
        .padding().navigationTitle("Sign Up")
    }

    private func signUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            alertMessage = "All fields are mandatory"
            isShowingAlert = true
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                if let user = authResult?.user {
                    let userInfo: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "role": selectedRole
                    ]
                    Database.database().reference().child("users").child(user.uid).setValue(userInfo) { error, _ in
                        if let error = error {
                            alertMessage = error.localizedDescription
                            isShowingAlert = true
                        } else {
                            isPresented = false
                            alertMessage = "Account created successfully"
                            isShowingAlert = true
                            email = ""
                            password = ""
                            confirmPassword = ""
                            firstName = ""
                            lastName = ""
                        }
                    }
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(isPresented: .constant(true))
    }
}
