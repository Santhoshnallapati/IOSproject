import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager: ObservableObject {
    
    @Published var Books: [AdminBookItem] = []
    private var database = Database.database().reference()
    
    private var currentUserID: String? {
           Auth.auth().currentUser?.uid
       }

    func addItem(_ item: AdminBookItem) {
           let itemRef = database.child("Books").child(item.id)
           itemRef.setValue([
               "bookname": item.bookname,
               "bookdescription": item.bookdescription,
               "Authorname": item.Authorname,
               "bookurl": item.bookurl,
               "isAvailable": item.isAvailable,
               "borrowedUserID": item.borrowedUserID ?? ""
           ]) { error, _ in
               if let error = error {
                   print("Error adding item: \(error.localizedDescription)")
               }
           }
       }
    
    
    func updateItem(_ item: AdminBookItem) {
          let itemRef = database.child("Books").child(item.id)
          itemRef.updateChildValues([
              "bookname": item.bookname,
              "bookdescription": item.bookdescription,
              "Authorname": item.Authorname,
              "bookurl": item.bookurl,
              "isAvailable": item.isAvailable,
              "borrowedUserID": item.borrowedUserID ?? ""
          ]) { error, _ in
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
        guard let userID = currentUserID else { return }
        
        var borrowedItem = item
        borrowedItem.isAvailable = false
        borrowedItem.borrowedUserID = userID
        
        let borrowedRef = database.child("borrowedBooks").child(userID).child(item.id)
        borrowedRef.setValue([
            "bookname": item.bookname,
            "bookdescription": item.bookdescription,
            "Authorname": item.Authorname,
            "bookurl": item.bookurl,
            "borrowedUserID": userID
        ]) { error, _ in
            if let error = error {
                print("Error borrowing item: \(error.localizedDescription)")
            }
        }
        
        updateItem(borrowedItem)
    }
    
    func returnBook(_ item: AdminBookItem) {
          guard let userID = currentUserID else { return }
          
          var returnedItem = item
          returnedItem.isAvailable = true
          returnedItem.borrowedUserID = nil
          
          let borrowedRef = database.child("borrowedBooks").child(userID).child(item.id)
          borrowedRef.removeValue { error, _ in
              if let error = error {
                  print("Error returning item: \(error.localizedDescription)")
              }
          }
          
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
                       
                       let borrowedUserID = value["borrowedUserID"] as? String
                       let item = AdminBookItem(id: snapshot.key,
                                                bookname: bookname,
                                                Authorname: Authorname,
                                                bookdescription: bookdescription,
                                                bookurl: bookurl,
                                                isAvailable: isAvailable,
                                                borrowedUserID: borrowedUserID)
                       books.append(item)
                   }
               }
               completion(books)
           }
       }
   }
    
