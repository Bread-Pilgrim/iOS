//
//  GetBakeryMyReviewsUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

protocol GetBakeryMyReviewsUseCase {
    func execute(_ id: Int, requestDTO: BakeryMyReviewRequestDTO) async throws -> Page<BakeryReview>
}

final class GetBakeryMyReviewsUseCaseImpl: GetBakeryMyReviewsUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ id: Int, requestDTO: BakeryMyReviewRequestDTO) async throws -> Page<BakeryReview> {
        return try await repository.getBakeryMyReviews(id, requestDTO: requestDTO)
    }
}

