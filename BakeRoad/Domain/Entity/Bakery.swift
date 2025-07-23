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
            rating: 4.7,
            reviewCount: 20203,
            gu: "관악구",
            dong: "신사동",
            openStatus: "O",
            imgUrl: "https://example.com/bakery1.jpg", // 실제 이미지 URL로 교체 필요
            isLike: false,
            signatureMenus: [
                .init(menuName: "꿀고구마휘낭시에"),
                .init(menuName: "에그타르트"),
                .init(menuName: "황치즈푸딩")
            ]
        ),
        Bakery(
            id: 2,
            name: "밸런스 베이커리",
            rating: 4.7,
            reviewCount: 20203,
            gu: "관악구",
            dong: "신사동",
            openStatus: "T", // 오늘 휴무
            imgUrl: "https://example.com/bakery2.jpg",
            isLike: false,
            signatureMenus: [
                .init(menuName: "소금빵"),
                .init(menuName: "올리브치즈 치아바타"),
                .init(menuName: "플레인 크로아상")
            ]
        ),
        Bakery(
            id: 3,
            name: "아띠 베이커리",
            rating: 4.7,
            reviewCount: 20203,
            gu: "관악구",
            dong: "신사동",
            openStatus: "C", // 영업종료
            imgUrl: "https://example.com/bakery3.jpg",
            isLike: false,
            signatureMenus: [
                .init(menuName: "소금빵"),
                .init(menuName: "햄치즈샌드위치")
            ]
        ),
        Bakery(
            id: 4,
            name: "큐브레드",
            rating: 4.7,
            reviewCount: 20203,
            gu: "관악구",
            dong: "신사동",
            openStatus: "O",
            imgUrl: "https://example.com/bakery4.jpg",
            isLike: false,
            signatureMenus: [
                .init(menuName: "생식빵"),
                .init(menuName: "맘모스빵"),
                .init(menuName: "잠봉뵈르 샌드위치")
            ]
        ),
        Bakery(
            id: 5,
            name: "서라당",
            rating: 4.7,
            reviewCount: 20203,
            gu: "관악구",
            dong: "신사동",
            openStatus: "O",
            imgUrl: "https://example.com/bakery5.jpg",
            isLike: false,
            signatureMenus: [
                .init(menuName: "꿀고구마휘낭시에"),
                .init(menuName: "에그타르트"),
                .init(menuName: "황치즈푸딩")
            ]
        )
    ]
}
