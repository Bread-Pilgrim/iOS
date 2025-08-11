//
//  BakeryRecommendResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

typealias BakeriesRecommendResponseDTO = [BakeryRecommendResponseDTO]

struct BakeryRecommendResponseDTO: Decodable {
    let bakeryID: Int
    let bakeryName: String
    let openStatus: String
    let imgURL: String
    let avgRating: Double
    let reviewCount: Int
    let commercialAreaID: Int

    enum CodingKeys: String, CodingKey {
        case bakeryID = "bakery_id"
        case bakeryName = "bakery_name"
        case openStatus = "open_status"
        case imgURL = "img_url"
        case avgRating = "avg_rating"
        case reviewCount = "review_count"
        case commercialAreaID = "commercial_area_id"
    }
}

extension BakeryRecommendResponseDTO {
    func toEntity() -> RecommendBakery {
        RecommendBakery(
            id: bakeryID,
            name: bakeryName,
            avgRating: avgRating,
            reviewCount: reviewCount,
            openStatus: openStatus,
            imgUrl: imgURL,
            commercialAreaId: commercialAreaID
        )
    }
}
