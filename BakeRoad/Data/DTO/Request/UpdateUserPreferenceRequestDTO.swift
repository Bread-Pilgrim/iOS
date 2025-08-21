//
//  UpdateUserPreferenceRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/20/25.
//

import Foundation

struct UpdateUserPreferenceRequestDTO: Encodable {
    let add: [Int]
    let delete: [Int]

    enum CodingKeys: String, CodingKey {
        case add = "add_preferences"
        case delete = "delete_preferences"
    }
}
