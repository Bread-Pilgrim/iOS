//
//  Notice.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

struct Notice: Identifiable, Equatable {
    let id: Int
    let title: String
    let contents: [String]
    var isExpanded: Bool = false
}
