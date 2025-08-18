//
//  ReviewLikeResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

struct ReviewLikeResponseDTO: Decodable {
    let isLike: Bool
    let reviewId: Int
    
    enum CodingKeys: String, CodingKey {
        case isLike = "is_like"
        case reviewId = "review_id"
    }
}
