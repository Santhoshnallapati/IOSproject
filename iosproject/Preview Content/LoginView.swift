import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showRegistrationView = false

    var body: some View {
        NavigationStack {
            VStack {
                Image(.libraryLogo)
                    .resizable()
                    .frame(width: 250, height: 200)
                    .scaledToFit()

                Text("Login")
                    .font(.largeTitle)
                    .padding()

                VStack {
                    TextField("Enter your Email", text: $username)
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

                    NavigationLink(destination: RegistrationView(isPresented: $showRegistrationView)) {
                        Text("New to Library? Sign Up").padding()
                    }
                    .padding()
                }
                .navigationBarTitle("Login")
            }
        }
    }

    private func login() {
            print(" login with email: \(username)")
            Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }
                
                // Successfully authenticated
                if let user = authResult?.user {
                    print("Login successful for user: \(user.email ?? "")")
                    DispatchQueue.main.async {
                        isLoggedIn = true
                        checkAdminPrivileges(for: user)
                    }
                }
            }
        }

    private func checkAdminPrivileges(for user: User) {
            let adminEmail = "Gaddamsubashreddy0519@gmail.com"
            
            DispatchQueue.main.async {
                if user.email == adminEmail {
                    print("Admin privileges granted")
                    isAdmin = true
                } else {
                    print("Regular user privileges granted")
                    isAdmin = false
                }
                print("isLoggedIn: \(isLoggedIn), isAdmin: \(isAdmin)")
            }
        }
    }
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false), isAdmin: .constant(false))
    }
}
