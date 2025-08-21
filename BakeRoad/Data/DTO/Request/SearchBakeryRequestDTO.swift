//
//  SearchBakeryRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

struct SearchBakeryRequestDTO: Encodable {
    let keyword: String
    let cursor: String
    let pageSize: Int

    private enum CodingKeys: String, CodingKey {
        case keyword
        case cursor = "cursor_value"
        case pageSize = "page_size"
    }
}
