//
//  LoginViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields

class LoginViewController: UIViewController, UITextFieldDelegate {
    private let userRepository: UserRepository! = ServiceProvider.shared.userRepository
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    @IBOutlet weak var passwordTextField: MDCFilledTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
    
    func setupUI() {
        setupMaterialAuthTextField(textField: emailTextField)
        setupMaterialAuthTextField(textField: passwordTextField)
        emailTextField.label.text = "Email"
        passwordTextField.label.text = "Password"
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        } else {
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

extension UIViewController {
    internal func setupMaterialAuthTextField(textField: MDCFilledTextField) {
        textField.setFilledBackgroundColor(UIColor.clear, for: .normal)
        textField.setUnderlineColor(UIColor.gray, for: .normal)
        textField.setFloatingLabelColor(UIColor.white, for: .normal)
        textField.setTextColor(UIColor.white, for: .normal)
        textField.setNormalLabelColor(UIColor.white, for: .normal)
        
        textField.setFilledBackgroundColor(UIColor.clear, for: .editing)
        textField.setUnderlineColor(UIColor.white, for: .editing)
        textField.setFloatingLabelColor(UIColor.white, for: .editing)
        textField.setTextColor(UIColor.white, for: .editing)
        textField.setNormalLabelColor(UIColor.white, for: .editing)
        textField.font = UIFont.boldSystemFont(ofSize: 16)
    }
}
