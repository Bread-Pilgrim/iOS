//
//  BakeryReviewRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

struct BakeryReviewRequestDTO: Encodable {
    var cursorValue: String
    var pageSize: Int
    var sortClause: SortOption

    private enum CodingKeys: String, CodingKey {
        case cursorValue = "cursor_value"
        case pageSize    = "page_size"
        case sortClause  = "sort_clause"
    }
}
