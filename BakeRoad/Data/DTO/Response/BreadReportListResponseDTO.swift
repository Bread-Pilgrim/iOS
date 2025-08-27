//
//  BreadReportListResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

struct BreadReportListResponseDTO: Decodable {
    let items: [BreadReportListItemDTO]
    let nextCursor: String?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case nextCursor = "next_cursor"
    }
}

struct BreadReportListItemDTO: Decodable {
    let year: Int
    let month: Int
}

extension BreadReportListItemDTO {
    func toEntity() -> BreadReportListItem {
        BreadReportListItem(year: year, month: month)
    }
}
