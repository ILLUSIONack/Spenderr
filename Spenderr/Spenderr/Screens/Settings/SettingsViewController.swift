//
//  SettingsViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 14/05/2021.
//

import UIKit

class SettingsViewController: UITableViewController {
    let userRepository = ServiceProvider.shared.userRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0): print("hello1")
        case (0,1): signOutButtonClicked()
        default: break
        }
    }

    private func signOutButtonClicked() {
        userRepository.signOut { result in
            switch result {
            case .success(_): self.showAlertDialog(title: "Signout", message: "This will log you out of your account", alertActions:
                                                [
                                                UIAlertAction(title: "Cancel", style: .cancel),
                                                UIAlertAction(title: "Signout", style: .destructive, handler: { _ in self.navigateToAuthentication() })
                                                ])
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    private func navigateToAuthentication() {
        let nvc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! UINavigationController
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true)
    }
    
    private func showAlertDialog(title: String, message: String, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertActions.forEach { (alertAction) in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
