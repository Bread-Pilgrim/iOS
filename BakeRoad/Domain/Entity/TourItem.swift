//
//  TourItem.swift
//  BakeRoad
//
//  Created by 이현호 on 7/21/25.
//

import Foundation

struct TourItem {
    let title: String
    let address: String
    let imageUrl: String
    let categoryName: String
}

extension TourItem {
    static let mockData: [TourItem] = [
        TourItem(
            title: "부산 시민공원",
            address: "부산 부산진구 시민공원로 73",
            imageUrl: "https://source.unsplash.com/343x192/?park",
            categoryName: "자연"
        ),
        TourItem(
            title: "해운대 해수욕장",
            address: "부산 해운대구 달맞이길62번길 47",
            imageUrl: "https://source.unsplash.com/343x192/?beach",
            categoryName: "레포츠"
        ),
        TourItem(
            title: "감천문화마을",
            address: "부산 사하구 감천로 203",
            imageUrl: "https://source.unsplash.com/343x192/?village,colorful",
            categoryName: "인문"
        ),
        TourItem(
            title: "광안리 바다",
            address: "부산 수영구 광안해변로",
            imageUrl: "https://source.unsplash.com/343x192/?sea,night",
            categoryName: "자연"
        ),
        TourItem(
            title: "부산타워",
            address: "부산 중구 용두산길 37-55",
            imageUrl: "https://source.unsplash.com/343x192/?tower,city",
            categoryName: "추천코스"
        )
    ]
}
