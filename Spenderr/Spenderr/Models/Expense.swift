//
//  Expense.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 29/09/2021.
//

import Foundation
import FirebaseFirestore

class Expense: CollectionItem {
    var data: Dictionary<String, Any>
    var name: String?
    var ammount: Int?
    var id: String
    var path: String
    var reference: DocumentReference
    var createdAt: Timestamp?
    
    init(userPath: String, name: String, ammount: Int) {
        self.name = name
        self.ammount = ammount
        self.id = UUID().uuidString
        self.path = userPath + "/expenses/" + self.id
        self.reference = ServiceProvider.shared.firestoreService.createReference(path: self.path)
        self.createdAt = Timestamp(date: Date())
        self.data = ["name": name, "ammount": ammount, "reference": self.reference, "createdAt": self.createdAt as Any]
    }
    
    init(document: FirestoreDocument) {
        self.data = document.data
        self.id = document.path
        self.path = document.path
        self.reference = ServiceProvider.shared.firestoreService.createReference(path: path)
    }
}
