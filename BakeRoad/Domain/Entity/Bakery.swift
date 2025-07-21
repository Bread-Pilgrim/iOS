//
//  Bakery.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Foundation

struct Bakery {
    let id: Int
    let name: String
    let rating: Double
    let reviewCount: Int
    let gu: String
    let dong: String
    let openStatus: String
    let imgUrl: String
    let isLike: Bool
    let signatureMenus: [SignatureMenu]
    
    struct SignatureMenu {
        let menuName: String
    }
}

extension Bakery {
    static let mockData: [Bakery] = [
        Bakery(
            id: 1,
            name: "서라당",
            rating: 4.8,
            reviewCount: 1204,
            gu: "관악구",
            dong: "신림동",
            openStatus: "O",
            imgUrl: "",
            isLike: true,
            signatureMenus: [
                .init(menuName: "꿀고구마휘낭시에"),
                .init(menuName: "에그타르트")
            ]
        ),
        Bakery(
            id: 2,
            name: "아띠 베이커리",
            rating: 4.6,
            reviewCount: 104,
            gu: "은평구",
            dong: "응암동",
            openStatus: "C",
            imgUrl: "",
            isLike: true,
            signatureMenus: [
                .init(menuName: "소금빵"),
                .init(menuName: "햄치즈샌드위치"),
                .init(menuName: "생식빵")
            ]
        )
    ]
}
