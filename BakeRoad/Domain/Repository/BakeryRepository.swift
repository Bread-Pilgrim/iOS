//
//  BakeryRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

protocol BakeryRepository {
    func getRecommendBakeries(_ type: RecommendBakeryType, areaCode: String) async throws -> [RecommendBakery]
}
