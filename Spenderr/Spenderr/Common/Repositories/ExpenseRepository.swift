//
//  ExpenseRepository.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 30/09/2021.
//

import Foundation
class ExpenseRepository {
    
    let firestoreService: FirestoreService!
    let userRepository: UserRepository!
    
    var currentUserId: String? {
        return self.userRepository.currentUserId
    }
    
    var expenses: [Expense] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        }
    }
    
    var totalExpenses: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBudget"), object: nil)
        }
    }
    
    init() {
        self.firestoreService = ServiceProvider.shared.firestoreService
        self.userRepository = ServiceProvider.shared.userRepository
        startObservingExpenses()
    }
    
    func startObservingExpenses() {
        guard let currentUserId = currentUserId else {
            return
        }
        firestoreService.observeCollection(path: "users/\(currentUserId)/expenses/") { (expenseList) in
            self.expenses = expenseList
            var expensesTotal = 0
            for expenses in expenseList {
                expensesTotal = expensesTotal + (expenses.data["ammount"] as! Int)
            }
            self.totalExpenses = expensesTotal
        }
    }
    
    func addExpense(userPath: String, name: String, ammount: Int, onComplete: @escaping (OperationResult<Bool>) -> Void) {
        let expense = Expense(userPath: userPath, name: name, ammount: ammount)
        firestoreService.createItem(item: expense, merge: false) { (error) in
            if let error = error {
                onComplete(OperationResult.failure(error))
            }
        }
        onComplete(OperationResult.success(true))
    }
}
