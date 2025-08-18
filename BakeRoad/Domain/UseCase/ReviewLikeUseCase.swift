//
//  ReviewLikeUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

protocol ReviewLikeUseCase {
    func execute(_ id: Int) async throws
}

final class ReviewLikeUseCaseImpl: ReviewLikeUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws {
        return try await repository.postReviewLike(id)
    }
}
