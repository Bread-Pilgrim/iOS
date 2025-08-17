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
    let phone: String
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
        
        private enum CodingKeys: String, CodingKey {
            case dayOfWeek = "day_of_week"
            case openTime = "open_time"
            case closeTime = "close_time"
            case isOpened = "is_opened"
        }
    }

    struct BakeryMenu: Decodable {
        let name: String
        let price: Int
        let isSignature: Bool
        let imgUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case name = "menu_name"
            case price
            case isSignature = "is_signature"
            case imgUrl = "img_url"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case bakeryId = "bakery_id"
        case bakeryName = "bakery_name"
        case address
        case phone
        case openStatus = "open_status"
        case operatingHours = "operating_hours"
        case isLike = "is_like"
        case bakeryImgUrls = "bakery_img_urls"
        case menus
    }
}

extension BakeryDetailResponseDTO {
    func toEntity() -> BakeryDetail {
        BakeryDetail(
            id: bakeryId,
            name: bakeryName,
            address: address,
            phone: phone,
            openStatus: BakeryOpenStatus(rawValue: openStatus) ?? .open,
            operatingHours: (operatingHours ?? []).map {
                BakeryDetail.OperatingHour(
                    dayOfWeek: $0.dayOfWeek,
                    openTime: $0.openTime,
                    closeTime: $0.closeTime,
                    isOpened: $0.isOpened
                )
            }.sortedByWeekday(),
            isLike: isLike,
            imageUrls: bakeryImgUrls ?? [],
            menus: (menus ?? []).map {
                BakeryDetail.BakeryMenu(
                    name: $0.name,
                    price: $0.price,
                    isSignature: $0.isSignature,
                    imageUrl: $0.imgUrl
                )
            }
        )
    }
}
