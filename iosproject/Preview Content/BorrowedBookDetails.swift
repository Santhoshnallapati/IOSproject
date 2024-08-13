//
//  BorrowedBookDetails.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-08-08.
//

import Foundation
import Firebase
import FirebaseDatabase

struct BorrowedBookDetail: Identifiable {
    var id: String { bookID }
    var userID: String
    var bookID: String
    var bookname: String
    var Authorname: String
    var bookdescription: String
    var bookurl: String
    var borrowDate: Date?
}

