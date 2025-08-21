//
//  BakeryMyReviewRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

struct BakeryMyReviewRequestDTO: Encodable {
    var cursorValue: String
    var pageSize: Int

    private enum CodingKeys: String, CodingKey {
        case cursorValue = "cursor_value"
        case pageSize    = "page_size"
    }
}
