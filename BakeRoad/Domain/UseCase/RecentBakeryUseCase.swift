//
//  RecentBakeryUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

protocol RecentBakeryUseCase {
    func execute() async throws -> [RecommendBakery]
}

final class RecentBakeryUseCaseImpl: RecentBakeryUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute() async throws -> [RecommendBakery] {
        return try await repository.getRecentBakeryList()
    }
}
