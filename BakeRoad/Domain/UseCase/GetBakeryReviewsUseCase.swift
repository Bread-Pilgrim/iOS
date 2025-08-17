//
//  GetBakeryReviewsUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/16/25.
//

import Foundation

protocol GetBakeryReviewsUseCase {
    func execute(_ id: Int, requestDTO: BakeryReviewRequestDTO) async throws -> BakeryReviewPage
}

final class GetBakeryReviewsUseCaseImpl: GetBakeryReviewsUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ id: Int, requestDTO: BakeryReviewRequestDTO) async throws -> BakeryReviewPage {
        return try await repository.getBakeryReviews(id, requestDTO: requestDTO)
    }
}
