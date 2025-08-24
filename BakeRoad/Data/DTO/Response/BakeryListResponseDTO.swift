//
//  BakeryListResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

struct BakeryListResponseDTO: Decodable {
    let items: [BakeryItemDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case items
        case nextCursor = "next_cursor"
    }
}

struct BakeryItemDTO: Decodable {
    let bakeryID: Int
    let bakeryName: String
    let openStatus: String
    let imgURL: String?
    let avgRating: Double
    let reviewCount: Int
    let gu: String
    let dong: String
    let commercialAreaID: Int?
    let signatureMenus: [SignatureMenuDTO]

    enum CodingKeys: String, CodingKey {
        case bakeryID = "bakery_id"
        case bakeryName = "bakery_name"
        case openStatus = "open_status"
        case imgURL = "img_url"
        case avgRating = "avg_rating"
        case reviewCount = "review_count"
        case gu, dong
        case commercialAreaID = "commercial_area_id"
        case signatureMenus = "signature_menus"
    }
}

struct SignatureMenuDTO: Codable, Hashable {
    let menuName: String

    enum CodingKeys: String, CodingKey {
        case menuName = "menu_name"
    }
}

extension BakeryItemDTO {
    func toEntity() -> Bakery {
        Bakery(id: bakeryID,
               name: bakeryName,
               openStatus: BakeryOpenStatus(rawValue: openStatus) ?? .open,
               imgUrl: imgURL,
               rating: avgRating,
               reviewCount: reviewCount,
               gu: gu,
               dong: dong,
               areaID: commercialAreaID ?? 14,
               signatureMenus: signatureMenus.map { $0.menuName })
    }
}

extension BakeryListResponseDTO {
    func toEntity() -> Page<Bakery> {
        let items = items.map { $0.toEntity() }
        return Page(items: items, nextCursor: nextCursor)
    }
}
