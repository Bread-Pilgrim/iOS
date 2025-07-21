//
//  AreasRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

protocol AreasRepository {
    func getAreaList() async throws -> [Area]
}
