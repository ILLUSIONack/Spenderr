//
//  CollectionItem.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 11/05/2021.
//

import Foundation

protocol CollectionItem: Item {
    var path: String {get set}
    var id: String {get set}
}
