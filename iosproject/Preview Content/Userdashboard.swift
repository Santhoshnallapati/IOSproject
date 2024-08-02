//
//  Userdashboard.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-08-02.
//


import SwiftUI

struct Userdashboard: View {
    @StateObject private var databaseManager = DatabaseManager()
    @State private var items: [AdminBookItem] = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
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
                        }
                    }
                }
                .onAppear {
                    databaseManager.fetchItem { fetchItem in
                        self.items = fetchItem
                    }
                }
            }
            .navigationTitle("Available Books")
        }
    }
}

struct UserDashboard_Previews: PreviewProvider {
    static var previews: some View {
        Userdashboard()
    }
}
