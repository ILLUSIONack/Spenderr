//
//  CollectionItem.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation

protocol CollectionItem {
    var path: String {get set}
    var data: Dictionary<String, Any> {get set}
}
