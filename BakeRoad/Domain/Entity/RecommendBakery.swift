//
//  RecommendRecommendBakery.swift
//  BakeRoad
//
//  Created by 이현호 on 7/21/25.
//

import Foundation

struct RecommendBakery: Identifiable {
    let id: Int
    let name: String
    let avgRating: Double
    let reviewCount: Int
    let openStatus: String
    let imgUrl: String
    let commercialAreaId: Int
}
