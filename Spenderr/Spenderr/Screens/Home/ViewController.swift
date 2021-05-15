//
//  ViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let firebaseService = ServiceProvider.shared.firebaseService
    let firestoreService = ServiceProvider.shared.firestoreService
    let userRepository = UserRepository()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseService.currentUserID != nil ? print("HERE") : navigateToAuthentication()
        print(userRepository.currentUser)
        print(userRepository.currentUserId)
    }

    private func navigateToAuthentication() {
        DispatchQueue.main.async {
            let nvc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! UINavigationController
            nvc.modalPresentationStyle = .fullScreen
            self.present(nvc, animated: true)
        }
    }
    @IBAction func settingsButtonPressed(_ sender: Any) {
        firebaseService.signOut { error in
            error == nil ? self.navigateToAuthentication() : nil
        }
    }
    
    
}

