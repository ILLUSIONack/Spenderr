//
//  ExpenseRepository.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 30/09/2021.
//

import Foundation
class ExpenseRepository {
    
    let firestoreService = ServiceProvider.shared.firestoreService
    let userRepository = ServiceProvider.shared.userRepository
    
    var expenses = [Expense]()
    
    init() {
        
    }
    
//    func startObservingExpenses(onComplete: @escaping (OperationResult<Bool>) -> Void) {
//        if let currentUser = userRepository.currentUser?.path {
//            let userExpensesPath = currentUser + "/expenses"
//            firestoreService.observeDocument(path: userExpensesPath) { (FirestoreDocument) -> CollectionItem in
//                Expense(document: FirestoreDocument)
//            }
//        }
//    }
    
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