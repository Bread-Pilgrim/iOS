//
//  BakeryReviewEligibilityResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

struct BakeryReviewEligibilityResponseDTO: Decodable {
    let isEligible: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEligible = "is_eligible"
    }
}
