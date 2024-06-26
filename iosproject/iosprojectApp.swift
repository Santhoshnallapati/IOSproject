//
//  iosprojectApp.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.
//

import SwiftUI
import Firebase

@main
struct IosProjectFinalApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        
        
        WindowGroup {
            ContentView()
        }
    }
}
