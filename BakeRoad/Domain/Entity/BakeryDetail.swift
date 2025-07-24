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

extension BakeryDetail {
    static let mockData = BakeryDetail(
        id: 1,
        name: "서라당",
        address: "서울시 관악구 신사로 120-1 1층 서라당",
        phone: "010-1234-5678",
        rating: 4.7,
        reviewCount: 100,
        openStatus: .open,
        operatingHours: [
            BakeryDetail.OperatingHour(
                dayOfWeek: "월",
                openTime: "10:00",
                closeTime: "20:00",
                isOpened: true
            )
        ],
        isLike: false,
        imageUrls: [
            "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4", // 대표 이미지
            "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
            "https://images.unsplash.com/photo-1578985545062-69928b1d9587"
        ],
        menus: [
            BakeryDetail.BakeryMenu(
                name: "바닐라 크림 케이크",
                price: 4500,
                isSignature: true,
                imageUrl: nil
            ),
            BakeryDetail.BakeryMenu(
                name: "마카롱 세트",
                price: 12000,
                isSignature: false,
                imageUrl: nil
            )
        ]
    )
}
