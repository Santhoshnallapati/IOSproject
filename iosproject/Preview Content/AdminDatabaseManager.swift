//
//  AdminDatabaseManager.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager :ObservableObject{
    
    @Published var Books: [AdminBookItem] = []
        private let database = Database.database().reference()
        
    private var userRole: String? {
         
          guard let userId = Auth.auth().currentUser?.uid else { return nil }
          let roleRef = database.child("users").child(userId).child("role")
          var role: String?
          
          roleRef.observeSingleEvent(of: .value) { snapshot in
              role = snapshot.value as? String
          }
          
          return role
      }

    func addItem(_ item: AdminBookItem){
        let itemRef = database.child("Books").child(item.id)
        itemRef.setValue(["bookname": item.bookname,"bookdescription":item.bookdescription,"Authorname" :item.Authorname, "bookurl" : item.bookurl, "isAvaialble " : item.isAvailable])
    }
    
    func updateItem(_ item: AdminBookItem){
        let itemRef = database.child("Books").child(item.id)
        itemRef.updateChildValues(["bookname": item.bookname,"bookdescription":item.bookdescription,"Authorname" :item.Authorname, "bookurl" : item.bookurl,"isAvaialble " : item.isAvailable])
    }
    
    func deleteItem(_ item: AdminBookItem){
        let itemRef = database.child("Books").child(item.id)
        itemRef.removeValue()
    }
    func borrowItem(_ item: AdminBookItem) {
            var borrowedItem = item
            borrowedItem.isAvailable = false
            updateItem(borrowedItem)
        }
    
    func fetchItem(completion: @escaping(([AdminBookItem]) -> Void )){
        database.child("Books").observe(.value){ snapShot in
            var Books:[AdminBookItem] = []
            for child in snapShot.children{
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let bookname = value["bookname"] as? String,
                   let bookdescription = value["bookdescription"] as? String,
                    let Authorname = value["Authorname"] as? String,
                    let bookurl = value["bookurl"] as? String,
                    let isAvailable = value["isAvailable"] as? Bool
                {
                    let item = AdminBookItem(id: snapshot.key,bookname : bookname,Authorname: Authorname, bookdescription: bookdescription, bookurl: bookurl,isAvailable: isAvailable)
                    Books.append(item)
                }
            }
            completion(Books)
        }
    }

}
