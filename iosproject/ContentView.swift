import SwiftUI

struct ContentView: View {
    @State private var isActive = true
    @State private var isLoggedIn = false
    @State private var isAdmin = false

    var body: some View {
        if isActive {
            SplashView(isActive: $isActive)
        } else if isLoggedIn {
            if isAdmin {
               
               AdminDashboard()
               
               
            } else {
               // AdminDashboard()
               DashboardView()
                
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
