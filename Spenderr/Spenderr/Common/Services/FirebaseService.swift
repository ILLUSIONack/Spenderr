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
                _ = onResult(OperationResult.success(result.user.uid))
            }
        }
    }
    
    func signIn(email: String, password: String, onResult: @escaping (OperationResult<String>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                onResult(OperationResult.failure(error) )
            } else if let result = result {
                UserDefaults.standard.setValue(result.user.displayName, forKey: "name")
                onResult(OperationResult.success(result.user.uid))
            }
        }
    }
    
    func signOut(onComplete: @escaping (OperationResult<String>) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "name")
            _ = onComplete(OperationResult.success("Logged out"))
        } catch let error {
            _ = onComplete(OperationResult.failure(error))
        }
    }
    
    func updateDisplayName(name: String, onComplete: @escaping (Error?) -> Void) {
        let request = Auth.auth().currentUser!.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { error in
            _ = onComplete(error)
        }
    }
}
