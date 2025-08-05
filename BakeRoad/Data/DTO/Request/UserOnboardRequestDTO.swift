//
//  UserOnboardRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

struct UserOnboardRequestDTO: Encodable {
    let nickname: String
    let bread_types: [Int]
    let flavors: [Int]
    let atmospheres: [Int]
}
