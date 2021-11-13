//
//  CreateAccountViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import UIKit
import MaterialComponents

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    let userRepository: UserRepository! = ServiceProvider.shared.userRepository
    let firestoreService: FirestoreService! = ServiceProvider.shared.firestoreService
    
    @IBOutlet weak var displayNameTextField: MDCFilledTextField!
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    @IBOutlet weak var passwordTextField: MDCFilledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
                            case .success(_, let user, _):
                                UserDefaults.standard.setValue(user.data["displayName"], forKey: "name")
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
    
    func setupUI() {
        displayNameTextField.label.text = "Display name"
        emailTextField.label.text = "Email"
        passwordTextField.label.text = "Password"
        displayNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupMaterialAuthTextField(textField: displayNameTextField)
        setupMaterialAuthTextField(textField: emailTextField)
        setupMaterialAuthTextField(textField: passwordTextField)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField == displayNameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            return true
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        }else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
