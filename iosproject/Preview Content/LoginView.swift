import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showRegistrationView = false
    @State private var navigateToDashboard: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Image("library_logo")
                    .resizable()
                    .frame(width: 250, height: 200)
                    .scaledToFit()

                Text("Login")
                    .font(.largeTitle)
                    .padding()

                VStack {
                    TextField("Enter your Email", text: $email)
                        .padding()
                        .frame(width: 400, height: 50, alignment: .center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)

                    SecureField("Enter Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textContentType(.password)

                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .padding()

                    NavigationLink(destination: RegistrationView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin), isActive: $showRegistrationView) {
                        Text("New to Library? Sign Up")
                            .padding()
                    }
                    .padding()

                    
                    NavigationLink(
                        destination: AdminDashboard(),
                        isActive: Binding(
                            get: { isLoggedIn && isAdmin && navigateToDashboard },
                            set: { _ in }
                        )
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: UserDashboard(),
                        isActive: Binding(
                            get: { isLoggedIn && !isAdmin && navigateToDashboard },
                            set: { _ in }
                        )
                    ) {
                        EmptyView()
                    }
                }
                .navigationBarTitle("Login")
            }
        }
    }

    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }
            
            if let user = authResult?.user {
                checkUserRole(for: user)
            }
        }
    }

    private func checkUserRole(for user: User) {
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                alertMessage = "Failed to retrieve user data"
                showAlert = true
                return
            }
            
            if let role = userData["role"] as? String {
                DispatchQueue.main.async {
                    isLoggedIn = true
                    isAdmin = (role == "Admin")
                    navigateToDashboard = true
                }
            } else {
                alertMessage = "Role not found"
                showAlert = true
            }
        } withCancel: { error in
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false), isAdmin: .constant(false))
    }
}
