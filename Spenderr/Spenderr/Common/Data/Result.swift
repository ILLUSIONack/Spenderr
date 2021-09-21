//
//  Result.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 15/05/2021.
//

import Foundation
enum Result<D, E> {
    case loading(state: State = State.loading, D?, E?)
    case notFound(state: State = State.notFound, D?, E?)
    case success(state: State = State.success, D, E?)
    case error(state: State = State.error, E, D?)
}

enum State: String {
    case loading = "loading"
    case notFound = "notFound"
    case success = "success"
    case error = "error"
}
