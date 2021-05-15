//
//  FirebaseService.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import Foundation
import Firebase

class FirebaseService {
    var currentUserID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var currentUserEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    var currentUserDisplayName: String? {
        return Auth.auth().currentUser?.displayName
    }
    
    func createAccount(email: String, password: String, onResult: @escaping (OperationResult<String>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                _ = onResult(OperationResult.failure(error))
            } else if let result = result {
                _ = onResult(OperationResult<String>.success(result.user.uid))
            }
        }
    }
    
    func signIn(email: String, password: String, onResult: @escaping (String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                onResult(error.localizedDescription)
            } else if let result = result {
                onResult(result.user.uid)
            }
        }
    }
    
    func signOut(onComplete: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            _ = onComplete(nil)
        } catch let error {
            _ = onComplete(error)
        }
    }
}
