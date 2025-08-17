//
//  GetBakeryReviewEligibility.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

protocol GetBakeryReviewEligibilityUseCase {
    func execute(_ id: Int) async throws -> BakeryReviewEligibilityResponseDTO
}

final class GetBakeryReviewEligibilityUseCaseImpl: GetBakeryReviewEligibilityUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws -> BakeryReviewEligibilityResponseDTO {
        return try await repository.getBakeryReviewEligibility(id)
    }
}
