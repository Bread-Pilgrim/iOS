//
//  BreadReportListRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

struct BreadReportListRequestDTO: Encodable {
    let cursorValue: String
    let pageSize: Int
    
    private enum CodingKeys: String, CodingKey {
        case cursorValue = "cursor_value"
        case pageSize    = "page_size"
    }
}
