//
//  ReviewDislikeUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

protocol ReviewDislikeUseCase {
    func execute(_ id: Int) async throws
}

final class ReviewDislikeUseCaseImpl: ReviewDislikeUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws {
        return try await repository.deleteReviewLike(id)
    }
}
