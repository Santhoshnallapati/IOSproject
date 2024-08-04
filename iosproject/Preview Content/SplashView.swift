import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var userRole: String? = nil
    @State private var isLoggedIn: Bool = false
    @State private var isAdmin: Bool = false

    var body: some View {
        VStack {
            Image("library_logo")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
        }
        .onAppear {
            checkUserStatus()
        }
        .fullScreenCover(isPresented: $isActive) {
            if isLoggedIn {
                if userRole == "Admin" {
                    AdminDashboard()
                } else {
                    UserDashboard()
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
            }
        }
    }

    private func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let ref = Database.database().reference().child("users").child(userId)
            
            ref.observeSingleEvent(of: .value) { snapshot in
                if let value = snapshot.value as? [String: Any],
                   let role = value["role"] as? String {
                    self.userRole = role
                }
                self.isLoggedIn = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    withAnimation {
//                        self.isActive = false
//                    }
                }
            }
        } 
//    else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                withAnimation {
//                    self.isActive = false
//                }
//            }
//        }
  //  }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isActive: .constant(true))
    }
}
