//
//  DeleteRecentBakeryUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/7/25.
//

import Foundation

protocol DeleteRecentBakeryUseCase {
    func execute() async throws
}

final class DeleteRecentBakeryUseCaseImpl: DeleteRecentBakeryUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute() async throws {
        return try await repository.deleteRecentBakeryList()
    }
}
