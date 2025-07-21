//
//  Set+Extensions.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Foundation

extension Set where Element: Hashable {
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
