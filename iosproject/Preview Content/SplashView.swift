//
//  SplashView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            Text("Library Management System")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Image(systemName: "book.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
        }
        .onAppear {
            print("SplashView appeared")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    print("Transitioning from SplashView")
                    self.isActive = false
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isActive: .constant(true))
    }
}





