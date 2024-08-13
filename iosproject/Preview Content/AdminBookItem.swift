//
//  AdminBookItem.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import Foundation
struct AdminBookItem:Identifiable,Codable{
    var id: String = UUID().uuidString
    var bookname : String
    var Authorname : String
    var bookdescription : String
    var bookurl : String
    var isAvailable: Bool = true
    var borrowedUserID: String?
    var borrowDate: Date?
    
    
    init(id: String = UUID().uuidString, bookname: String, Authorname: String, bookdescription: String, bookurl: String, isAvailable: Bool = true, borrowedUserID: String? = nil, borrowDate: Date? = nil) {
        self.id = id
        self.bookname = bookname
        self.Authorname = Authorname
        self.bookdescription = bookdescription
        self.bookurl = bookurl
        self.isAvailable = isAvailable
        self.borrowedUserID = borrowedUserID
        self.borrowDate = borrowDate
    }

}




