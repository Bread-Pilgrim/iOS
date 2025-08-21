//
//  GetUserPreferencesResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/20/25.
//

import Foundation

struct GetUserPreferencesResponseDTO: Decodable {
    let breadTypes: [UserPreferenceTypeDTO]
    let flavors: [UserPreferenceTypeDTO]
    let atmospheres: [UserPreferenceTypeDTO]

    enum CodingKeys: String, CodingKey {
        case breadTypes = "bread_types"
        case flavors
        case atmospheres
    }
}

struct UserPreferenceTypeDTO: Decodable {
    let preference_id: Int
    let preference_name: String
}
