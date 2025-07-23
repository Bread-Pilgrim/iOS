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
    let menus: [Menu]?
    
    struct OperatingHour: Decodable {
        let day: String
        let open: String
        let close: String
        let isClosed: Bool
    }

    struct Menu: Decodable {
        let menuName: String
        let price: Int
        let isSignature: Bool
        let imgUrl: String?
    }
}
