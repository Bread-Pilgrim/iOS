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
    
    var hasNext: Bool {
        return nextCursor != nil
    }
    
    static var empty: Page<T> { Page(items: [], nextCursor: nil) }
}
