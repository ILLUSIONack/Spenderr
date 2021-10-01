//
//  DataSyncHelper.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 14/05/2021.
//

import Foundation
import Firebase
let userDefaults = UserDefaults.standard

class ServiceProvider {
    static let shared = ServiceProvider()
    private var didInitializeDataSync = false
    
    var firestoreService: FirestoreService!
    var userRepository: UserRepository!
    var expenseRepository: ExpenseRepository!
    
    
    func initalizeServiceProviderIfNeeded() {
        if !didInitializeDataSync {
            didInitializeDataSync = true
            FirebaseApp.configure()
            
            firestoreService = FirestoreService()
            userRepository = UserRepository(firebaseService: FirebaseService())
            expenseRepository = ExpenseRepository()
            
            if true {
                Firestore.firestore().clearPersistence { error in
                    guard let _ = error else {
//                        userDefaults.set(ServiceProvider.shared.userRepository.currentUserId, forKey: "UID")
                        return
                    }
                }
            }
        }
    }
}
