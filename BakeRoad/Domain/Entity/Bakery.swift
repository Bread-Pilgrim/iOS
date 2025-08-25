//
//  Bakery.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
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

struct Bakery: Identifiable, Equatable {
    let id: Int
    let name: String
    let openStatus: BakeryOpenStatus
    let imgUrl: String?
    let rating: Double
    let reviewCount: Int
    let gu: String
    let dong: String
    let areaID: Int
    let signatureMenus: [String]
}
