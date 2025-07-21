//
//  AreasMapper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

enum AreasMapper {
    static func map(from dto: AreasReponseDTO) -> Area {
        return Area(code: dto.areaCode, name: dto.areaName)
    }
}
