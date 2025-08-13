//
//  BakeryListRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

struct BakeryListRequestDTO: Encodable {
    let area_code: String
    let page_no: Int
    let page_size: Int
}
