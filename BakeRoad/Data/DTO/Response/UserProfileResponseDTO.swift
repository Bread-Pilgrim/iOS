//
//  UserProfileResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/25/25.
//

import Foundation

struct UserProfileResponseDTO: Decodable {
    let nickname: String
    let profileImg: String?
    let badgeName: String
    let isRepresentative: Bool
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImg = "profile_img"
        case badgeName = "badge_name"
        case isRepresentative = "is_representative"
    }
}

extension UserProfileResponseDTO {
    func toEntity() -> UserProfile {
        UserProfile(
            nickname: nickname,
            profileImg: profileImg,
            badgeName: badgeName,
            isRepresentative: isRepresentative
        )
    }
}
