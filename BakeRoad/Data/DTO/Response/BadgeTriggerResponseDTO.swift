//
//  BadgeTriggerResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 9/6/25.
//

import Foundation

struct BadgeTriggerResponseDTO: Decodable {
    let type: String
    let badge_id: Int
    let badge_name: String
    let badge_img: String
    let description: String
}

extension BadgeTriggerResponseDTO {
    func toEntity() -> Badge {
        let baseURL = "https://rmpwbqnjauejvolxmamj.supabase.co/storage/v1/object/public/bread-bucket/images/"
        
        return Badge(
            id: badge_id,
            name: badge_name,
            description: description,
            imgUrl: baseURL+badge_img,
            isEarned: true,
            isRepresentative: false
        )
    }
}
