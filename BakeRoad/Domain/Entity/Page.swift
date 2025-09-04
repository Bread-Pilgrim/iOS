//
//  Page.swift
//  BakeRoad
//
//  Created by 이현호 on 8/25/25.
//

import Foundation

struct Page<T> {
    var items: [T]
    var nextCursor: String?
}
