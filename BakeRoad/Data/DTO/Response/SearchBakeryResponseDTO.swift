//
//  SearchBakeryResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

struct SearchBakeryResponseDTO: Decodable {
    let items: [BakeryItemDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case items
        case nextCursor = "next_cursor"
    }
}
