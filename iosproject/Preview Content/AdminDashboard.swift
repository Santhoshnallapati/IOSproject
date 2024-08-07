//
//  AdminDashboard.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import SwiftUI

struct AdminDashboard: View {
    @StateObject private var databaseManager = DatabaseManager()
    @State private var Books:[AdminBookItem] = []
    @State private var newItemName = ""
    @State private var newItemAuthor = ""
    @State private var newItemdescription = ""
    @State private var newItemurl = ""
    @State private var isEditeMode = false
    @State private var selectedItem : AdminBookItem?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(Books){ item in
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
                        self.Books = fetchItem
                         
                    }
                }
                
                VStack{
                    
                    TextField("bookName",text: $newItemName)
                        .padding()
                    TextField("Description",text: $newItemdescription)
                    TextField("Author name",text: $newItemAuthor)
                   TextField("ImageURL",text: $newItemurl)
                    
                    Button(isEditeMode ? "Update" : "Add"){
                        if newItemName.isEmpty || newItemdescription.isEmpty || newItemAuthor.isEmpty || newItemurl.isEmpty {
                            alertMessage = "All fields are mandatory. Please fill in all fields."
                            showAlert = true
                        }
                        else{
                            if isEditeMode, let item = selectedItem {
                                var updateditem = item
                                updateditem.bookname = newItemName
                                updateditem.bookdescription = newItemdescription
                                updateditem.Authorname = newItemAuthor
                                updateditem.bookurl = newItemurl
                                databaseManager.updateItem(updateditem)
                                isEditeMode = false
                            }
                            
                            else{
                                
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
                    .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                        }
                }
                .padding()
            
                
                HStack{
                    
                    NavigationLink(destination: Profilepage()) {
                        Text("Go to Profile")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    NavigationLink(destination: AboutLibraryView()) {
                        Text("About Library")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    
                    
                   
                }
                
            }
            .navigationTitle("Books : ")
            .navigationBarItems(trailing: EditButton())
        }
        
    }
    
    private func deleteItems(at offsets : IndexSet){
        for index in offsets{
            let item = Books[index]
            databaseManager.deleteItem(item)
        }
        Books.remove(atOffsets: offsets)
    }
}



struct AdminDashboard_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboard()
    }
}
