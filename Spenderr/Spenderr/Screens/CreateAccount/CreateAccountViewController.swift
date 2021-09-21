//
//  CreateAccountViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import UIKit

class CreateAccountViewController: UIViewController {
    let userRepository = ServiceProvider.shared.userRepository
    let firestoreService = ServiceProvider.shared.firestoreService
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        if !emailTextField.text!.isEmpty || !passwordTextField.text!.isEmpty || !displayNameTextField.text!.isEmpty {
            userRepository.createAccount(displayName: displayNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { result in
                switch result {
                case .success(let userId):
                    print(userId)
                    DispatchQueue.main.async {
                        self.firestoreService.getDocument(path: "users/\(userId)") { document in
                            User(document: document)
                        } onComplete: { result in
                            switch result {
                
                            case .loading(state: let state, _, _):
                                print(state)
                            case .notFound(state: let state, _, _):
                                print(state)
                            case .success(_, _, _):
                                self.dismiss()
                            case .error(state: let state, _, _):
                                print(state)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlertDialog(title: "Error", message: error.localizedDescription, alertActions: [UIAlertAction(title: "OK", style: .default)])
                }
            }
        } else {
            showAlertDialog(title: "Not all fields are filled in", message: "Fill in the missing fields", alertActions: [UIAlertAction(title: "OK", style: .default)])
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss(){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAlertDialog(title: String, message: String, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertActions.forEach { (alertAction) in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
