//
//  OperationResult.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 15/05/2021.
//

import Foundation

enum OperationResult<Value> {
    case success(Value)
    case failure(Error)
}
