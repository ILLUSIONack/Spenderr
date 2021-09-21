//
//  OperationResult.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 15/05/2021.
//

import Foundation

enum OperationResult<T> {
    case success(T)
    case failure(Error)
}
