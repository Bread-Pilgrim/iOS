//
//  GetPreferencesResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

struct GetPreferencesResponseDTO: Decodable {
    let breadType: [PreferenceTypeDTO]
    let flavor: [PreferenceTypeDTO]
    let atmosphere: [PreferenceTypeDTO]

    enum CodingKeys: String, CodingKey {
        case breadType = "bread_type"
        case flavor
        case atmosphere
    }
}

struct PreferenceTypeDTO: Decodable {
    let id: Int
    let name: String
}
