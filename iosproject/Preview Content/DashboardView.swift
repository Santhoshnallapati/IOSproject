//
//  DashboardView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.


import SwiftUI

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
            }.navigationTitle("User")
        }
        .padding()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}


