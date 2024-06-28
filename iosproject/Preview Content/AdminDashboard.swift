//
//  AdminDashboard.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import SwiftUI

struct AdminDashboard: View {
    
    @StateObject private var databaseManager = DatabaseManager()
    @State private var items:[AdminBookItem] = []
    @State private var newItemName = ""
    @State private var newItemAuthor = ""
    @State private var newItemdescription = ""
    @State private var newItemurl = ""
    @State private var isEditeMode = false
    @State private var selectedItem : AdminBookItem?
    
    var body: some View {
        
            VStack{
                List{
                    ForEach(items){ item in
                        VStack(alignment : .leading){
                            
                            
                            Text(item.bookname).font(.headline)
                            Text(item.Authorname).font(.headline)
                            Text(item.bookdescription).font(.subheadline)
                            
                            AsyncImage(url: URL(string :item.bookurl)) { phase in
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
                            
                           //Text(item.bookurl).font(.subheadline)
                        }
                        .onTapGesture {
                            selectedItem = item
                            newItemName = item.bookname
                            newItemdescription = item.bookdescription
                            newItemAuthor = item.Authorname
                             newItemurl = item.bookurl
                            isEditeMode = true
                        }
                        
                    }
                    .onDelete(perform : deleteItems)
                }
                .onAppear{
                    databaseManager.fetchItem{ fetchItem in
                        self.items = fetchItem
                         
                    }
                }
                
                HStack{
                    TextField("bookName",text: $newItemName)
                        .padding()
                    TextField("Description",text: $newItemdescription)
                    TextField("Author name",text: $newItemAuthor)
                   TextField("ImageURL",text: $newItemurl)
                    
                    Button(isEditeMode ? "Update" : "Add"){
                        if isEditeMode, let item = selectedItem {
                            var updateditem = item
                            updateditem.bookname = newItemName
                            updateditem.bookdescription = newItemdescription
                            updateditem.Authorname = newItemAuthor
                            updateditem.bookurl = newItemurl
                            databaseManager.updateItem(updateditem)
                            isEditeMode = false
                        }else{
                            let newItem = AdminBookItem(bookname: newItemName, Authorname:  newItemAuthor, bookdescription: newItemdescription,bookurl:newItemurl)
                          databaseManager.addItem(newItem)
                        }
                        newItemName = ""
                        newItemdescription = ""
                        newItemAuthor = ""
                        newItemurl = ""
                        selectedItem = nil
                    }
                }
                .padding()
            }
            .navigationTitle("AdminBookItem : ")
            .navigationBarItems(trailing: EditButton())
        }
    private func deleteItems(at offsets : IndexSet){
        for index in offsets{
            let item = items[index]
            databaseManager.deleteItem(item)
        }
        items.remove(atOffsets: offsets)
    }

    }
    



struct ContentView_preview : PreviewProvider{
    static var previews: some View{
        AdminDashboard()
    }
}


