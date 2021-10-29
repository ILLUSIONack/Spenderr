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
    
    var expenses : [String] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
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
            var expenses = [String]()

            for expense in expenseList {
                expenses.append(expense.data["name"] as! String)
            }
            self.expenses = expenses
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
