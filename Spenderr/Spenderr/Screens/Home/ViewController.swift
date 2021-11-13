//
//  ViewController.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import UIKit
import Firebase

protocol ViewControllerDelegate {
    func scrollToTop()
}

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate, ViewControllerDelegate {

    let userRepository = ServiceProvider.shared.userRepository
    let expenseRepository = ServiceProvider.shared.expenseRepository
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var budgetView: UIView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var noSpendingLabel: UILabel!
    @IBOutlet weak var titleTextField: UILabel!
    var totalExpenses: Int {
        if let totalExpenses = self.expenseRepository?.totalExpenses {
            return totalExpenses
        }
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBudget), name: NSNotification.Name(rawValue: "reloadBudget"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        expenseRepository?.startObservingExpenses()
    }
    
    @objc func reloadTableView(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    @objc func reloadBudget(notification: NSNotification) {
        self.budgetLabel.text = "€ \(totalExpenses)"
    }
    
    func loadData() {
        DispatchQueue.main.async {
            guard let name = UserDefaults.standard.object(forKey: "name") as? String else {
                return self.navigateToAuthentication()
            }
            self.titleTextField.text = name
            self.budgetLabel.text = "€ \(self.totalExpenses)"
        }
    }
    
    func scrollToTop() {
//        let topRow = IndexPath(row: 0, section: 0)
//        self.tableView.scrollToRow(at: topRow, at: .top, animated: true)        
        self.tableView.setContentOffset( CGPoint(x: 0, y: 0) , animated: true)
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            // Setup tableview and navigation background color and title
            self.tableView.backgroundColor = .white
            self.tableView.tableHeaderView?.backgroundColor = .white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name:"Belfort",size: 20)!]
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name:"Belfort", size: 40)!]
            
            self.budgetView.layer.masksToBounds = true
            self.budgetView.layer.cornerRadius = 9
            
            self.noSpendingLabel.isHidden = true
            
            self.tableView.isHidden = false
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let nvc = UIStoryboard(name: "AddSpending", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let vc = nvc.viewControllers[0] as! AddSpendingViewController
        vc.viewControllerDelegate = self
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

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let expenses = expenseRepository?.expenses.count ?? 0
        noSpendingLabel.isHidden = expenses != 0
        return expenses == 0 ? 0 : expenses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.nameLabel.text = (expenseRepository?.expenses[indexPath.row].data["name"] as! String)
        cell.priceLabel.text = "€ \((expenseRepository?.expenses[indexPath.row].data["ammount"] as! Int))"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 150
        print(budgetView.bounds.size.height)
        print(offset)
        if offset > 0.5 {
            UIView.animate(withDuration: 0.2) {
                
                self.navigationController?.navigationBar.topItem?.title = "\(self.totalExpenses)"
                self.navigationController?.navigationBar.backgroundColor = .black
            }
        } else {
            self.navigationController?.navigationBar.backgroundColor = .white
            self.navigationController?.navigationBar.topItem?.title = "Balance"
        }
    }
}
