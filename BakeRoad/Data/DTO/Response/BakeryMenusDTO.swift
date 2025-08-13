//
//  BakeryMenusDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/30/25.
//

import Foundation

typealias BakeryMenusDTO = [BakeryMenuDTO]

struct BakeryMenuDTO: Decodable {
    let menu_id: Int
    let menu_name: String
    let is_signature: Bool
}

extension BakeryMenuDTO {
    func toEntity() -> BakeryMenu {
        BakeryMenu(
            id: menu_id,
            name: menu_name,
            isSignature: is_signature
        )
    }
}
