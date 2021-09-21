//
//  ViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import UIKit
import Firebase

protocol ViewControllerDelegate {
    func loadData()
}

class ViewController: UIViewController, ViewControllerDelegate {
    let userRepository = ServiceProvider.shared.userRepository
    
    @IBOutlet weak var titleTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData() {
        print("Loaddata is called")
        DispatchQueue.main.async {
            if let currentUser = self.userRepository.currentUser {
                self.titleTextField.text = "Hey " + (currentUser.data["displayName"] as! String) + "!"
            } else {
                self.navigateToAuthentication()
            }
        }
    }
    
    private func navigateToAuthentication() {
        let nvc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! UINavigationController
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true)
    }
    
    private func navigateToSettings() {
        let nvc = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let vc = nvc.viewControllers[0] as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        navigateToSettings()
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        
    }
    
    private func showAlertDialog(title: String, message: String, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertActions.forEach { (alertAction) in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

