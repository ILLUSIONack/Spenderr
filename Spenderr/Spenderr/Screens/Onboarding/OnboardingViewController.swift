//
//  OnboardingViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 13/05/2021.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = 10
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateInitialViewController() as! CreateAccountViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
