//
//  BakeryLikeResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

struct BakeryLikeResponseDTO: Decodable {
    let isLike: Bool
    let bakeryId: String
    
    enum CodingKeys: String, CodingKey {
        case isLike = "is_like"
        case bakeryId = "bakery_id"
    }
}
