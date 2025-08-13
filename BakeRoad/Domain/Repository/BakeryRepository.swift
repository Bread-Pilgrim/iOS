//
//  BakeryRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

protocol BakeryRepository {
    func getRecommendBakeries(_ type: BakeryType, areaCode: String) async throws -> [RecommendBakery]
    func getBakeryList(_ type: BakeryType, request: BakeryListRequestDTO) async throws -> Page<Bakery>
}
