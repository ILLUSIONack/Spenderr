//
//  File.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation
import FirebaseFirestore

class User: CollectionItem {
    var path: String
    var id: String
    var data: Dictionary<String, Any>
    var displayName: String?
    var email: String?
    var reference: DocumentReference
    
    init(displayName: String, email:String, path: String) {
        self.path = "users/" + path
        self.id = path
        self.reference = ServiceProvider.shared.firestoreService.createReference(path: "users/" + path)
        self.data = ["displayName": displayName, "email": email, "reference": self.reference]
        self.displayName = displayName
        self.email = email
    }
    
    init(document: FirestoreDocument) {
        self.path = document.path
        self.data = document.data
        self.id = document.path
        self.reference = ServiceProvider.shared.firestoreService.createReference(path: path)
    }
}
