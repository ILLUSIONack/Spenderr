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
            self.totalExpenses = expenseList.map { expense in expense.data["ammount"] }.reduce(0) { partialResult, number in
                partialResult + (number as! Int)
            }
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
    
    func deleteExpense(expensePath: String, onComplete: @escaping (String?) -> Void) {
        firestoreService.deleteItem(path: expensePath) { error in
            if let error = error {
                _ = onComplete(error.localizedDescription)
            }
            _ = onComplete(nil)
        }
    }
}
