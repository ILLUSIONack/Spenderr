//
//  SettingsViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 14/05/2021.
//

import UIKit

class SettingsViewController: UITableViewController {
    let userRepository: UserRepository! = ServiceProvider.shared.userRepository
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        nameLabel.text = userRepository.currentUserDisplayName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0): print("hello1")
        case (0,1): signOutButtonClicked()
        default: break
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    private func signOutButtonClicked() {
        self.showAlertDialog(title: "Signout", message: "This will log you out of your account", alertActions:
                                [
                                    UIAlertAction(title: "Cancel", style: .cancel),
                                    UIAlertAction(title: "Signout", style: .destructive, handler: { _ in
                                        self.userRepository.signOut { result in
                                            switch result {
                                            case .success(_): self.presentingViewController?.dismiss(animated: true, completion: nil)
                                            case .failure(let error): print(error.localizedDescription)
                                            }
                                        }
                                    })
                                ])
        
    }
    
    private func showAlertDialog(title: String, message: String, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertActions.forEach { (alertAction) in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
