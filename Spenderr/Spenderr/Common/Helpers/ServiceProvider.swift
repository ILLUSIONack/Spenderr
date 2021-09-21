//
//  DataSyncHelper.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 14/05/2021.
//

import Foundation
import Firebase

class ServiceProvider {
    static let shared = ServiceProvider()
    private var didInitializeDataSync = false
    
    func initalizeServiceProviderIfNeeded() {
        if !didInitializeDataSync {
            didInitializeDataSync = true
            FirebaseApp.configure()
        }
    }
    
    lazy var firestoreService = FirestoreService()
    lazy var firebaseService = FirebaseService()
    lazy var userRepository = UserRepository()
}
