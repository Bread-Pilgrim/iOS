//
//  BakeryReviewRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation
  
enum ReviewSortClause: String, Codable {
    case likeCountDesc   = "LIKE_COUNT.DESC"   // 좋아요순
    case createdAtDesc   = "CREATED_AT.DESC"   // 최신 작성순
    case ratingDesc      = "RATING.DESC"       // 높은 평점순
    case ratingAsc       = "RATING.ASC"        // 낮은 평점순
}

struct BakeryReviewRequestDTO: Encodable {
    var pageNo: Int
    var pageSize: Int
    var sortClause: ReviewSortClause

    private enum CodingKeys: String, CodingKey {
        case pageNo     = "page_no"
        case pageSize   = "page_size"
        case sortClause = "sort_clause"
    }
}
