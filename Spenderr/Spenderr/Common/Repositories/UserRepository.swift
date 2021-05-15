//
//  UserRepository.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 14/05/2021.
//

import Foundation

class UserRepository {
    let firebaseService = ServiceProvider.shared.firebaseService
    let firestoreService = ServiceProvider.shared.firestoreService
    var currentUserId = {
        return ServiceProvider.shared.firebaseService.currentUserID
    }()
    var currentUser: User?
    
    init() {
        startObservingUser()
    }
    
    private func startObservingUser() {
        if let currentUserId = currentUserId {
            firestoreService.observeDocument(path: "users/" + currentUserId) { FirestoreDocument in
                let user = User(document: FirestoreDocument)
                self.currentUser = user
                return user
            }
        }
        
    }
    
    func createAccount(displayName: String, email: String, password: String, onComplete: @escaping (OperationResult<String>) -> Void) {        
        firebaseService.createAccount(email: email, password: password) { result in
            switch result {
            case .success(let data):
                let userItem = User(displayName: displayName, email: email, path: data)
                self.firestoreService.createItem(item: userItem, merge: false) { error in
                    if let error = error {
                        onComplete(OperationResult.failure(error))
                    }
                }
                onComplete(OperationResult<String>.success(data))
            case .failure(let error):
                onComplete(OperationResult.failure(error))
            }
        }
    }
}
