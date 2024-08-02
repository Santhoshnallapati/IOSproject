import Foundation
import FirebaseDatabase

class DatabaseManager: ObservableObject {
    
    @Published var Books: [AdminBookItem] = []
    private let database = Database.database().reference()
    private let currentUserID = "currentUserID"
    
    
    func addItem(_ item: AdminBookItem) {
        let itemRef = database.child("Books").child(item.id)
        itemRef.setValue(["bookname": item.bookname,
                          "bookdescription": item.bookdescription,
                          "Authorname": item.Authorname,
                          "bookurl": item.bookurl,
                          "isAvailable": item.isAvailable]) { error, _ in
            if let error = error {
                print("Error adding item: \(error.localizedDescription)")
            }
        }
    }
    
    func updateItem(_ item: AdminBookItem) {
        let itemRef = database.child("Books").child(item.id)
        itemRef.updateChildValues(["bookname": item.bookname,
                                   "bookdescription": item.bookdescription,
                                   "Authorname": item.Authorname,
                                   "bookurl": item.bookurl,
                                   "isAvailable": item.isAvailable]) { error, _ in
            if let error = error {
                print("Error updating item: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteItem(_ item: AdminBookItem) {
        let itemRef = database.child("Books").child(item.id)
        itemRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting item: \(error.localizedDescription)")
            }
        }
    }
    
    func borrowItem(_ item: AdminBookItem) {
        var borrowedItem = item
        borrowedItem.isAvailable = false
        updateItem(borrowedItem)
    }
    
    func returnBook(_ item: AdminBookItem) {
        var returnedItem = item
        returnedItem.isAvailable = true
        updateItem(returnedItem)
    }
    
    func fetchItem(completion: @escaping ([AdminBookItem]) -> Void) {
        database.child("Books").observe(.value) { snapshot in
            var books: [AdminBookItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let bookname = value["bookname"] as? String,
                   let bookdescription = value["bookdescription"] as? String,
                   let Authorname = value["Authorname"] as? String,
                   let bookurl = value["bookurl"] as? String,
                   let isAvailable = value["isAvailable"] as? Bool {
                    
                    let item = AdminBookItem(id: snapshot.key,
                                             bookname: bookname,
                                             Authorname: Authorname,
                                             bookdescription: bookdescription,
                                             bookurl: bookurl,
                                             isAvailable: isAvailable)
                    books.append(item)
                }
            }
            completion(books)
        }
    }
}
