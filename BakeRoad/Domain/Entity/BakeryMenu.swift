//
//  BakeryMenu.swift
//  BakeRoad
//
//  Created by 이현호 on 7/30/25.
//

import Foundation

struct BakeryMenu: Identifiable, Equatable {
    let id: Int               // menu_id
    let name: String          // menu_name
    let isSignature: Bool     // is_signature
}

extension BakeryMenu {
    static let mockData: [BakeryMenu] = [
        BakeryMenu(id: 1, name: "꿀고구마 휘낭시에", isSignature: true),
        BakeryMenu(id: 2, name: "초코 휘낭시에", isSignature: false),
        BakeryMenu(id: 3, name: "여기에 없어요 😶", isSignature: false)
    ]
}
