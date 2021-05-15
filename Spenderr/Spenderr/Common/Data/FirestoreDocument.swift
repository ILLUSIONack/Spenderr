//
//  FirestoreDocument.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 15/05/2021.
//

import Foundation

class FirestoreDocument {
    var path: String
    var data: Dictionary<String, Any>
    
    init(path: String, data: Dictionary<String, Any>) {
        self.path = path
        self.data = data
    }
}
