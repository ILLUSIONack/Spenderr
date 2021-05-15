//
//  FirestoreService.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation
import FirebaseFirestore
import Firebase

class FirestoreService {
    
    // MARK: - Create
    func createReference(path: String) -> DocumentReference {
        let db = Firestore.firestore()
        return db.document(path)
    }
    
    func createItem(item: CollectionItem, merge: Bool, onComplete: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let reference = db.document(item.path)
        reference.setData(item.data) { error in
            if let error = error {
                onComplete(error)
            } else {
                onComplete(nil)
            }
        }
    }
    
    // MARK: - Read
    
    func observeDocument(path: String, transform: @escaping (FirestoreDocument) -> CollectionItem) {
        let db = Firestore.firestore()
        db.document(path)
            .addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                let fireStoreDocument = FirestoreDocument(path: path, data: document.data()!)
                _  = transform(fireStoreDocument)
                print("\(source) data: \(document.data() ?? [:])")
            }
    }
}
