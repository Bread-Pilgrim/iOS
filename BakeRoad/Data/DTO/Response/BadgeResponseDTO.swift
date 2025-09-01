//
//  BadgeResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import Foundation

struct BadgeResponseDTO: Decodable {
    let badge_id: Int
    let badge_name: String
    let description: String
    let img_url: String
    let is_earned: Bool
    let is_representative: Bool?
}

extension BadgeResponseDTO {
    func toEntity() -> Badge {
        Badge(
            id: badge_id,
            name: badge_name,
            description: description,
            img: img_url,
            isEarned: is_earned,
            isRepresentative: is_representative ?? false
        )
    }
}
