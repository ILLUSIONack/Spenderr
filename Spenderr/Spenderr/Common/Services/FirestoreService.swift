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
                if let data = document.data() {
                    let fireStoreDocument = FirestoreDocument(path: path, data: data)
                    _  = transform(fireStoreDocument)
                }
              
                print("\(source) data: \(document.data() ?? [:])")
            }
    }
    
    func getDocument(path: String, transform: @escaping (FirestoreDocument) -> CollectionItem, onComplete: @escaping (Result<CollectionItem, Error>) -> Void) {
        let db = Firestore.firestore()
        onComplete(Result.loading(nil, nil))
        db.document(path).getDocument { (document, error) in
            if let error = error {
                _ = onComplete(Result.error(error, nil))
            }
            
            if let document = document {
              if document.exists, let data = document.data() {
                let firestoreDocument = FirestoreDocument(path: path, data: data)
                let success: Result<CollectionItem, Error> = Result.success( transform(firestoreDocument), nil)
                  _ = onComplete(success)
              } else {
                onComplete(Result.notFound(nil, nil))
              }
            }
        }
    }
}
