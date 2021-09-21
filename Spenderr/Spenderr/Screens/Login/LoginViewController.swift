//
//  LoginViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import UIKit

class LoginViewController: UIViewController {
    private let userRepository = UserRepository()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if !emailTextField.text!.isEmpty || !passwordTextField.text!.isEmpty {
            userRepository.signIn(email: emailTextField.text!, password: passwordTextField.text!) { result in
                switch result {
                case .success(let userId):
                    print(userId + " User loged in")
                    
                    self.dismiss()
                case .failure(let error):
                    self.showAlertDialog(title: "Error", message: error.localizedDescription, alertActions: [UIAlertAction(title: "OK", style: .default)])
                }
            }
        } else {

            self.showAlertDialog(title: "Error", message: "One of the two text fields is empty", alertActions: [UIAlertAction(title: "OK", style: .default)])
        }
    }
    
    private func dismiss() {
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
