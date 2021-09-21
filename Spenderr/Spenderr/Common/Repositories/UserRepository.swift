//
//  UserRepository.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 14/05/2021.
//

import Foundation
import Firebase

class UserRepository {
    let firebaseService = ServiceProvider.shared.firebaseService
    let firestoreService = ServiceProvider.shared.firestoreService
    var currentUserId = {
        return ServiceProvider.shared.firebaseService.currentUserID
    }()
    var currentUserDisplayName = {
        return ServiceProvider.shared.firebaseService.currentUserDisplayName
    }()
    var currentUser: User?
    
    init() {
        fetchUser()
        startObservingUser()
    }
    
    private func startObservingUser() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.firestoreService.observeDocument(path: "users/" + user.uid) { firestoreDocument in
                    let userModel = User(document: firestoreDocument)
                    self.currentUser = userModel
                    return userModel
                }
            }
        }
    }
    
    private func fetchUser() {
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
            case .success(let userId):
                let userItem = User(displayName: displayName, email: email, userId: userId)
                self.firestoreService.createItem(item: userItem, merge: false) { error in
                    if let error = error {
                        onComplete(OperationResult.failure(error))
                    }
                }
                self.firebaseService.updateDisplayName(name: displayName) { error in
                    if let error = error {
                        onComplete(OperationResult.failure(error))
                    }
                }
                onComplete(OperationResult.success(userId))
            case .failure(let error):
                onComplete(OperationResult.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, onComplete: @escaping (OperationResult<String>) -> Void) {
        firebaseService.signIn(email: email, password: password) { result in
            switch result {
            case .success(let data):
                onComplete(OperationResult.success(data))
            case .failure(let error): onComplete(OperationResult.failure(error))
            }
        }
    }
    
    func signOut(onComplete: @escaping (OperationResult<String>) -> Void) {
        firebaseService.signOut { result in
            switch result {
            case .success(let data):
                onComplete(OperationResult.success(data))
            case .failure(let error):
                onComplete(OperationResult.failure(error))
            }
        }
    }
}
