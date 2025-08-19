//
//  WriteReviewUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

protocol WriteReviewUseCase {
    func execute(_ id: Int, request: WriteReviewRequestDTO, imageData: [Data]) async throws
}

final class WriteReviewUseCaseImpl: WriteReviewUseCase {
    private let repository: BakeryRepository
    
    init(repository: BakeryRepository) {
        self.repository = repository
    }
    
    func execute(_ id: Int, request: WriteReviewRequestDTO, imageData: [Data]) async throws {
        try await repository.writeReview(id, requestDTO: request, imageData: imageData)
    }
}
