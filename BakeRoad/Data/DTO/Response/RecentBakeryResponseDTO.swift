//
//  RecentBakeryResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

struct RecentBakeryResponseDTO: Decodable {
    let bakery_id: Int
    let bakery_name: String
    let open_status: String
    let img_url: String
    let avg_rating: Double
    let review_count: Int
    let commercial_area_id: Int
}

extension RecentBakeryResponseDTO {
    func toEntity() -> RecommendBakery {
        RecommendBakery(
            id: bakery_id,
            name: bakery_name,
            avgRating: avg_rating,
            reviewCount: review_count,
            openStatus: open_status,
            imgUrl: img_url,
            commercialAreaId: commercial_area_id
        )
    }
}
