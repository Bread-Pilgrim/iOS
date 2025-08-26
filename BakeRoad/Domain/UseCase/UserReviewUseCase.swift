//
//  UserReviewUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import Foundation

protocol UserReviewUseCase {
    func execute(_ requestDTO: UserReviewRequestDTO) async throws -> Page<UserReview>
}

final class UserReviewUseCaseImpl: UserReviewUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(_ requestDTO: UserReviewRequestDTO) async throws -> Page<UserReview> {
        return try await repository.getUserReview(requestDTO)
    }
}
