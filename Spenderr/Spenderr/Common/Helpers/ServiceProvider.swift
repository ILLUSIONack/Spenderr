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
    
    func initalizeServiceProviderIfNeeded() {
        if !didInitializeDataSync {
            didInitializeDataSync = true
            FirebaseApp.configure()
            
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
    
    lazy var firestoreService = FirestoreService()
    lazy var userRepository = UserRepository(firebaseService: FirebaseService())
}
