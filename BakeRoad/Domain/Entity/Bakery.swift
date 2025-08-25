//
//  Bakery.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Foundation

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
