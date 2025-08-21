//
//  BakeryListRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

struct BakeryListRequestDTO: Encodable {
    let area_code: String
    let cursor_value: String
    let page_size: Int
}
