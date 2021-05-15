//
//  CreateAccountViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import UIKit

class CreateAccountViewController: UIViewController {
    let userRepository = UserRepository()
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
                case .success(_):
                    self.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            // TODO : Alert the user with message
            print("One of the three fields are empty")
        }
    }
    
    func dismiss(){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
