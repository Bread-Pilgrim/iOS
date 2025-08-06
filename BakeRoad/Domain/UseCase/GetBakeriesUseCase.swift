//
//  GetBakeriesUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

protocol GetBakeriesUseCase {
    func execute(_ type: RecommendBakeryType) async throws -> [RecommendBakery]
}

final class GetBakeriesUseCaseImpl: GetBakeriesUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ type: RecommendBakeryType) async throws -> [RecommendBakery] {
        return try await repository.getRecommendBakeries(type)
    }
}

