//
//  RecommendRecommendBakery.swift
//  BakeRoad
//
//  Created by 이현호 on 7/21/25.
//

import Foundation

enum RecommendBakeryType: String {
    case preference
    case hot
    
    var endpoint: String {
        switch self {
        case .preference:
            return BakeryEndPoint.recommendPreferenceList
        case .hot:
            return BakeryEndPoint.recommendHotList
        }
    }
}

struct RecommendBakery: Identifiable {
    let id: Int
    let name: String
    let avgRating: Double
    let reviewCount: Int
    let openStatus: String
    let imgUrl: String
    let isLike: Bool
    let commercialAreaId: Int
}
