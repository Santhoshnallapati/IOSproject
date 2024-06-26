//
//  ContentView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = Auth.auth().currentUser != nil
    @State private var isSplashScreenActive = true
    
    var body: some View {
        VStack {
            if isSplashScreenActive {
                SplashView(isActive: $isSplashScreenActive)
            } else {
                if isLoggedIn {
                    DashboardView()
                } else {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
            }
        }
        .onAppear {
            checkUserStatus()
        }
    }
    
    private func checkUserStatus() {
        // Check if the user is already logged in
        if Auth.auth().currentUser != nil {
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
