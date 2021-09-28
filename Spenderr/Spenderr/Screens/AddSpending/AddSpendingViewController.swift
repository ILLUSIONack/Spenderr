//
//  AddSpendingViewController.swift
//  Spenderr
//
//  Created by Lord Kevin Kevinson of Kevinton on 29/09/2021.
//

import UIKit

class AddSpendingViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor.clear
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
