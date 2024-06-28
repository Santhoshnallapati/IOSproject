//
//  DashboardView.swift
//  iosproject
//
//  Created by Santhosh Nallapati on 2024-06-25.
//

import SwiftUI



struct DashboardView: View {
    @State private var searchText = ""
    @State private var books = [String]()
    @State private var borrowedBooks = [String]()
    
//    let db = Firestore.firestore()
    
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
            
//            NavigationLink(destination: BorrowedBooksView(borrowedBooks: $borrowedBooks)) {
//                Text("View Borrowed Books")
//                    .frame(minWidth: 0, maxWidth: .infinity)
//                    .padding()
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
        }
        .padding()
//        .onAppear(perform: fetchBooks)
    }
    
//    private func fetchBooks() {
//        db.collection("books").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting books: \(error)")
//                return
//            }
//            books = querySnapshot?.documents.map { $0["title"] as! String } ?? []
//        }
//    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
