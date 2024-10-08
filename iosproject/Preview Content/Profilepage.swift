import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct Profilepage: View {
    @State private var profileName: String = ""
    @State private var profileEmail: String = ""
    @State private var profileRole: String = ""
    @State private var isLoggedIn: Bool = true
    @State private var isAdmin: Bool = true
    @State private var showingLogoutAlert: Bool = false
    @State private var showingLoginView: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                if isLoggedIn {
                    Text("Name: \(profileName)")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 16)

                    Text("Email: \(profileEmail)")
                        .font(.system(size: 16))
                        .padding(.top, 8)

                    Text("Role: \(profileRole)")
                        .font(.system(size: 16))
                        .padding(.top, 8)

                    Button(action: {
                        self.showingLogoutAlert = true
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 16)
                    .alert(isPresented: $showingLogoutAlert) {
                        Alert(
                            title: Text("Confirm Logout"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .destructive(Text("Logout")) {
                                logout()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    .padding(.top, 16)
                }
            }
            .padding(20)
            HStack{
                
                NavigationLink(destination: UserDashboard()) {
                    Text("Available books")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                NavigationLink(destination: AboutLibraryView()) {
                    Text("About Library")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                
                
               
            }
            .onAppear {
                fetchUserData()
            }
            .fullScreenCover(isPresented: $showingLoginView) {
                LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
            }
        }
    }
    
    func fetchUserData() {
        let database = Database.database().reference()
        guard let currentUser = Auth.auth().currentUser else {
            self.isLoggedIn = false
            return
        }
        
        let userEmail = currentUser.email
        
        let ref = database.child("users")
        
        ref.queryOrdered(byChild: "email").queryEqual(toValue: userEmail).observeSingleEvent(of: .value) { snapshot in
            if let userSnapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for userSnapshot in userSnapshots {
                    if let userData = userSnapshot.value as? [String: Any] {
                        let firstName = userData["firstName"] as? String ?? ""
                        let lastName = userData["lastName"] as? String ?? ""
                        let email = userData["email"] as? String ?? ""
                        let role = userData["role"] as? String ?? ""
                        let profileName = "\(firstName) \(lastName)"
                        let profileEmail = email
                        let profileRole = role
                        
                        self.profileName = profileName
                        self.profileEmail = profileEmail
                        self.profileRole = profileRole
                    }
                }
            } else {
                print("No user data found")
            }
        } withCancel: { error in
            print("Failed to load user data: \(error.localizedDescription)")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            showingLoginView = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct Profilepage_Previews: PreviewProvider {
    static var previews: some View {
        Profilepage()
    }
}
