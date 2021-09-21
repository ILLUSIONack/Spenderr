//
//  File.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation
import FirebaseFirestore

class User: CollectionItem {
    var data: Dictionary<String, Any>
    var displayName: String?
    var email: String?
    var id: String
    var path: String
    var reference: DocumentReference
    
    init(displayName: String, email:String, userId: String) {
        self.displayName = displayName
        self.email = email
        self.id = userId
        self.path = "users/" + userId
        self.reference = ServiceProvider.shared.firestoreService.createReference(path: "users/" + userId)
        self.data = ["displayName": displayName, "email": email, "reference": self.reference]

    }
    
    init(document: FirestoreDocument) {
        self.data = document.data
        self.id = document.path
        self.path = document.path
        self.reference = ServiceProvider.shared.firestoreService.createReference(path: path)
    }
}
