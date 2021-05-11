//
//  FirestoreService.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation
import Firebase

class FirestoreService {
    
    // MARK: - Create
    static func createItem(item: CollectionItem) {
        let db = Firestore.firestore()
        let data = item.data
        let path = item.path
        var ref: DocumentReference? = nil
        ref = db.collection(path).addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // MARK: - Read
    // TODO
}
