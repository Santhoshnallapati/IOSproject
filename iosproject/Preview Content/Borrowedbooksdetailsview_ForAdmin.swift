//
//  Borrowedbooksdetailsview_ForAdmin.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-08-08.
//


import SwiftUI

struct Borrowedbooksdetailsview_ForAdmin: View {
    
    @StateObject private var databaseManager = DatabaseManager()
        @State private var borrowedBooks: [BorrowedBookDetail] = []
        
        var body: some View {
            VStack {
                List(borrowedBooks) { item in
                    VStack(alignment: .leading) {
                        Text("Book Name: \(item.bookname)").font(.headline)
                        Text("Author: \(item.Authorname)").font(.subheadline)
                        Text("Description: \(item.bookdescription)").font(.body)
                        if let borrowDate = item.borrowDate {
                            Text("Borrowed on: \(borrowDate, formatter: DateFormatter.shortDate)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Text("User ID: \(item.userID)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        AsyncImage(url: URL(string: item.bookurl)) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            case .failure:
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            default:
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                .onAppear {
                    databaseManager.fetchAllBorrowedBooks { books in
                        self.borrowedBooks = books
                    }
                }
            }
            .navigationTitle("Borrowed Books Details")
        }
    
    
}

struct Borrowedbooksdetailsview_ForAdmin_Previews: PreviewProvider {
    static var previews: some View {
        Borrowedbooksdetailsview_ForAdmin()
    }
}

