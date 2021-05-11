//
//  File.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation

class User: CollectionItem {
    var path: String
    var data: Dictionary<String, Any>
    var first: String
    var last: String
    
    init(first: String, last:String) {
        self.first = first
        self.last = last
        self.data = ["first": first, "last": last]
        self.path = "users"
    }
}
