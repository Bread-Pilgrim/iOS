//
//  BakeryDetailResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import Foundation

struct BakeryDetailResponseDTO: Decodable {
    let bakeryId: Int
    let bakeryName: String
    let address: String
    let phone: String?
    let avgRating: Double
    let reviewCount: Int
    let openStatus: String
    let operatingHours: [OperatingHour]?
    let isLike: Bool
    let bakeryImgUrls: [String]?
    let menus: [BakeryMenu]?
    
    struct OperatingHour: Decodable {
        let dayOfWeek: Int
        let openTime: String
        let closeTime: String
        let isOpened: Bool
    }

    struct BakeryMenu: Decodable {
        let name: String
        let price: Int
        let isSignature: Bool
        let imageUrl: String?
    }
}
