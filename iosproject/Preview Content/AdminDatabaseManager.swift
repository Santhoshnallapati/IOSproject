import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager: ObservableObject {
    
    @Published var Books: [AdminBookItem] = []
    @Published var BorrowedBooks: [AdminBookItem] = []
    private var database = Database.database().reference()
    
     var currentUserID: String? {
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
               "borrowedUserID": item.borrowedUserID ?? "",
               "borrowDate": item.borrowDate?.timeIntervalSince1970 ?? NSNull()
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
              "borrowedUserID": item.borrowedUserID ?? "",
              "borrowDate": item.borrowDate?.timeIntervalSince1970 ?? NSNull()
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
    func borrowItem(_ item: AdminBookItem, completion: @escaping () -> Void) {
            guard let userID = currentUserID else { return }
            var borrowedItem = item
            borrowedItem.isAvailable = false
            borrowedItem.borrowedUserID = userID
            borrowedItem.borrowDate = Date()
            
            database.child("Books").child(item.id).updateChildValues([
                "isAvailable": borrowedItem.isAvailable,
                "borrowedUserID": borrowedItem.borrowedUserID ?? "",
                "borrowDate": borrowedItem.borrowDate?.timeIntervalSince1970 ?? NSNull()
            ]) { error, _ in
                if error == nil {
                    self.database.child("BorrowedBooks").child(userID).child(item.id).setValue([
                        "bookname": item.bookname,
                        "bookdescription": item.bookdescription,
                        "Authorname": item.Authorname,
                        "bookurl": item.bookurl,
                        "borrowedUserID": userID,
                        "borrowDate": borrowedItem.borrowDate?.timeIntervalSince1970 ?? NSNull()
                    ]) { error, _ in
                        if error == nil {
                            completion()
                        }
                    }
                }
            }
        }

        func returnBook(_ item: AdminBookItem, completion: @escaping () -> Void) {
            guard let userID = currentUserID else {
                return
            }
            var returnedItem = item
            returnedItem.isAvailable = true
            returnedItem.borrowedUserID = nil
            returnedItem.borrowDate = nil
            
            database.child("Books").child(item.id).updateChildValues([
                "isAvailable": returnedItem.isAvailable,
                "borrowedUserID": NSNull(),
                "borrowDate": NSNull()
                
            ]) { error, _ in
                if error == nil {
                    self.database.child("BorrowedBooks").child(userID).child(item.id).removeValue { error, _ in
                        if error == nil {
                            completion()
                        }
                    }
                }
            }
        }
    
    func fetchBorrowedBooks(completion: @escaping ([AdminBookItem]) -> Void) {
            guard let userID = currentUserID else { 
                return
            }
            database.child("BorrowedBooks").child(userID).observeSingleEvent(of: .value) { snapshot in
                var books: [AdminBookItem] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let value = snapshot.value as? [String: Any],
                       let bookname = value["bookname"] as? String,
                       let bookdescription = value["bookdescription"] as? String,
                       let Authorname = value["Authorname"] as? String,
                       let bookurl = value["bookurl"] as? String,
                       let borrowedUserID = value["borrowedUserID"] as? String,
                       let borrowDate = (value["borrowDate"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }{
                        
                        let item = AdminBookItem(id: snapshot.key,
                                                 bookname: bookname,
                                                 Authorname: Authorname,
                                                 bookdescription: bookdescription,
                                                 bookurl: bookurl,
                                                 isAvailable: false,
                                                 borrowedUserID: borrowedUserID,
                                                 borrowDate: borrowDate)
                        books.append(item)
                    }
                }
                completion(books)
            }
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
                      let isAvailable = value["isAvailable"] as? Bool
                   {
                      let borrowedUserID = value["borrowedUserID"] as? String
                      let borrowDate = (value["borrowDate"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0)
                      }
                       
                       
                       let item = AdminBookItem(
                           id: snapshot.key,
                           bookname: bookname,
                           Authorname: Authorname,
                           bookdescription: bookdescription,
                           bookurl: bookurl,
                           isAvailable: isAvailable,
                           borrowedUserID: borrowedUserID,
                           borrowDate: borrowDate
                       )
                       books.append(item)
                   }
               }
               completion(books)
           }
       }
   }
