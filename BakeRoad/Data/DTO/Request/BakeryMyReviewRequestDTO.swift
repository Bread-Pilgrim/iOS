//
//  BakeryMyReviewRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

struct BakeryMyReviewRequestDTO: Encodable {
    var pageNo: Int
    var pageSize: Int

    private enum CodingKeys: String, CodingKey {
        case pageNo     = "page_no"
        case pageSize   = "page_size"
    }
}
