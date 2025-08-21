//
//  BakeryMyReviewResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

struct BakeryMyReviewResponseDTO: Decodable {
    let reviews: [BakeryReviewDTO]
    let nextCursor: String?
    
    private enum CodingKeys: String, CodingKey {
        case reviews = "items"
        case nextCursor = "next_cursor"
    }
}
