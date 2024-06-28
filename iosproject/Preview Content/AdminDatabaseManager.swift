//
//  AdminDatabaseManager.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import Foundation

import FirebaseDatabase


class DatabaseManager :ObservableObject{
    
    private let database = Database.database().reference();
    
    func addItem(_ item: AdminBookItem){
        let itemRef = database.child("items").child(item.id)
        itemRef.setValue(["bookname": item.bookname,"bookdescription":item.bookdescription,"Authorname" :item.Authorname, "bookurl" : item.bookurl])
    }
    
    func updateItem(_ item: AdminBookItem){
        let itemRef = database.child("items").child(item.id)
        itemRef.updateChildValues(["bookname": item.bookname,"bookdescription":item.bookdescription,"Authorname" :item.Authorname, "bookurl" : item.bookurl])
    }
    
    func deleteItem(_ item: AdminBookItem){
        let itemRef = database.child("items").child(item.id)
        itemRef.removeValue()
    }
    
    func fetchItem(completion: @escaping(([AdminBookItem]) -> Void )){
        database.child("items").observe(.value){ snapShot in
            var items:[AdminBookItem] = []
            for child in snapShot.children{
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let bookname = value["bookname"] as? String,
                   let bookdescription = value["bookdescription"] as? String,
                    let Authorname = value["Authorname"] as? String,
                    let bookurl = value["bookurl"] as? String {
                    let item = AdminBookItem(id: snapshot.key,bookname : bookname,Authorname: Authorname, bookdescription: bookdescription, bookurl: bookurl)
                    items.append(item)
                }
            }
            completion(items)
        }
    }

}

