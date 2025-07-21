//
//  AreasReponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

struct AreasReponseDTO: Decodable {
    let areaCode: Int
    let areaName: String
    
    enum CodingKeys: String, CodingKey {
        case areaCode = "area_code"
        case areaName = "area_name"
    }
}
