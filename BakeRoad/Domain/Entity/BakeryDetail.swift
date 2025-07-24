//
//  BakeryDetail.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import Foundation

struct BakeryDetail: Equatable {
    let id: Int
    let name: String
    let address: String
    let phone: String?
    let rating: Double
    let reviewCount: Int
    let openStatus: BakeryOpenStatus
    let operatingHours: [OperatingHour]
    let isLike: Bool
    let imageUrls: [String]
    let menus: [BakeryMenu]

    struct OperatingHour: Equatable {
        let dayOfWeek: String?
        let openTime: String?
        let closeTime: String?
        let isOpened: Bool?
    }

    struct BakeryMenu: Equatable {
        let name: String
        let price: Int
        let isSignature: Bool
        let imageUrl: String?
    }
}
