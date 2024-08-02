//
//  DashboardView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.

import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    @State private var searchText = ""
    @State private var books = [String]()
    @State private var borrowedBooks = [String]()
    
    var body: some View {
        VStack {
            Text("Library Dashboard")
                .font(.largeTitle)
                .padding()
            
            TextField("Search Books", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                ForEach(books.filter { $0.contains(searchText) || searchText.isEmpty }, id: \.self) { book in
                    HStack {
                        Text(book)
                        Spacer()
                        Button(action: {
                            if !borrowedBooks.contains(book) {
                                borrowedBooks.append(book)
                            }
                        }) {
                            Text("Borrow")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("User")
            
            Button(action: {
                logout()
            }) {
                Text("Logout")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding()
        }
        .padding()
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
