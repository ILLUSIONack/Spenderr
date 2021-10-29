//
//  ViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    let userRepository = ServiceProvider.shared.userRepository
    let expenseRepository = ServiceProvider.shared.expenseRepository
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var budgetView: UIView!
    @IBOutlet weak var noSpendingLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        for family: String in UIFont.familyNames
               {
                   print(family)
                   for names: String in UIFont.fontNames(forFamilyName: family)
                   {
                       print("== \(names)")
                   }
               }
        loadData()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        expenseRepository?.startObservingExpenses()
    }
    
    @objc func reloadTableView(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    func loadData() {
        DispatchQueue.main.async {
            guard let name = UserDefaults.standard.object(forKey: "name") as? String else {
                return self.navigateToAuthentication()
            }
            self.titleTextField.text = name
        }
    }
    
    private func setupUI() {
        budgetView.layer.masksToBounds = true
        budgetView.layer.cornerRadius = 9
        noSpendingLabel.isHidden = true
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func navigateToAuthentication() {
        let nvc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! UINavigationController
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true)
    }
    
    private func navigateToSettings() {
        let nvc = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as! UINavigationController
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
    
   
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        navigateToSettings()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let nvc = UIStoryboard(name: "AddSpending", bundle: nil).instantiateInitialViewController() as! UINavigationController
        if #available(iOS 13.0, *) {
            nvc.modalPresentationStyle = .automatic
            nvc.presentationController?.delegate = self
        } else {
            nvc.modalPresentationStyle = .fullScreen
            nvc.view.backgroundColor = UIColor.clear
            nvc.view.isOpaque = false
        }
        present(nvc, animated: true)
    }
    
    private func showAlertDialog(title: String, message: String, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertActions.forEach { (alertAction) in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let expenses = expenseRepository?.expenses.count ?? 0
        if expenses == 0 {
            noSpendingLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noSpendingLabel.isHidden = true
            tableView.isHidden = false
        }
        return expenses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.nameLabel.text = expenseRepository?.expenses[indexPath.row]
        return cell
    }
    
}
