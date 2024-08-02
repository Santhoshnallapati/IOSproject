//
//  UserDashboard.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import SwiftUI

struct UserDashboard: View {
    @StateObject private var databaseManager = DatabaseManager()
    @State private var selectedItem: AdminBookItem?
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(databaseManager.Books) { item in
                        VStack(alignment: .leading) {
                            Text(item.bookname).font(.headline)
                            Text(item.Authorname).font(.headline)
                            Text(item.bookdescription).font(.subheadline)
                            
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
                                @unknown default:
                                    Image(systemName: "photo")
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if item.isAvailable {
                                Button("Borrow") {
                                    selectedItem = item
                                    showingAlert = true
                                }
                                .padding(.top, 5)
                                .foregroundColor(.blue)
                            } else {
                                Text("Unavailable")
                                    .foregroundColor(.red)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Confirm Borrow"),
                        message: Text("Do you want to borrow \(selectedItem?.bookname ?? "this book")?"),
                        primaryButton: .default(Text("Yes")) {
                            if let item = selectedItem {
                                databaseManager.borrowItem(item)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Available Books")
        }
    }
}

struct UserDashboard_Previews: PreviewProvider {
    static var previews: some View {
        UserDashboard()
    }
}
