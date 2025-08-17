//
//  BakeryLikeUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

protocol BakeryLikeUseCase {
    func execute(_ id: Int) async throws
}

final class BakeryLikeUseCaseImpl: BakeryLikeUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws {
        return try await repository.postBakeryLike(id)
    }
}
