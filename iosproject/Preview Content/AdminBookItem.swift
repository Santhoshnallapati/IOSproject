//
//  AdminBookItem.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-06-27.
//

import Foundation

struct AdminBookItem: Identifiable {
    var id = UUID()
    var bookname: String
    var Authorname: String
    var bookdescription: String
    var bookurl: String
    var isAvailable: Bool = true
}



