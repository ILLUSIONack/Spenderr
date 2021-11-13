//
//  AddSpendingViewController.swift
//  Spenderr
//
//  Created by Lord Kevin Kevinson of Kevinton on 29/09/2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields

class AddSpendingViewController: UIViewController {
    
    let expenseRepository: ExpenseRepository! = ServiceProvider.shared.expenseRepository
    let userRepository: UserRepository! = ServiceProvider.shared.userRepository
    
    var viewControllerDelegate: ViewControllerDelegate?
    @IBOutlet weak var nameTextField: MDCFilledTextField!
    @IBOutlet weak var ammountTextField: MDCFilledTextField!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var panelView: UIView!
    
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if !nameTextField.text!.isEmpty || !ammountTextField.text!.isEmpty {
            guard let userPath = userRepository.currentUser?.path else {
                return self.showAlertDialog(title: "Error", message: "Cannot recieve user", alertActions: [UIAlertAction(title: "OK", style: .default)])
            }
            expenseRepository.addExpense(userPath: userPath, name: nameTextField.text!, ammount: Int(ammountTextField.text!)!) { (result) in
                switch result {
                case .success(_):
                    self.viewControllerDelegate?.scrollToTop()
                    self.navigationController?.dismiss(animated: true, completion: nil)
                case .failure(let error):  self.showAlertDialog(title: "Error", message: error.localizedDescription, alertActions: [UIAlertAction(title: "OK", style: .default)])
                }
            }
        } else {
            showAlertDialog(title: "Fields Empty", message: "Please fill in both fields", alertActions: [UIAlertAction(title: "OK", style: .default)])
        }
    }
    
    func setupUI() {
        nameTextField.label.text = "Name"
        ammountTextField.label.text = "Ammount"
        setupMaterialAuthTextField(textField: nameTextField)
        setupMaterialAuthTextField(textField: ammountTextField)
        backgroundView.backgroundColor = UIColor.clear
        panelView.clipsToBounds = true
        panelView.layer.cornerRadius = 10
        panelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
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
        } else if textField == nameTextField {
            textField.resignFirstResponder()
            ammountTextField.becomeFirstResponder()
            return true
        } else if textField == ammountTextField {
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
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
