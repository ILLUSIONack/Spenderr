//
//  AddSpendingViewController.swift
//  Spenderr
//
//  Created by Lord Kevin Kevinson of Kevinton on 29/09/2021.
//

import UIKit

class AddSpendingViewController: UIViewController {
    
    let expenseRepository = ServiceProvider.shared.expenseRepository
    let userRepository = ServiceProvider.shared.userRepository
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor.clear
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if !nameTextField.text!.isEmpty || !ammountTextField.text!.isEmpty {
            guard let userPath = userRepository.currentUser?.path else {
                return self.showAlertDialog(title: "Error", message: "Cannot recieve user", alertActions: [UIAlertAction(title: "OK", style: .default)])
            }
            expenseRepository.addExpense(userPath: userPath, name: nameTextField.text!, ammount: Int(ammountTextField.text!)!) { (result) in
                switch result {
                case .success(_): self.navigationController?.dismiss(animated: true, completion: nil)
                case .failure(let error):  self.showAlertDialog(title: "Error", message: error.localizedDescription, alertActions: [UIAlertAction(title: "OK", style: .default)])
                }
            }
        }
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
}
