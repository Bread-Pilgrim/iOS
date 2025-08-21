//
//  SearchBakeryUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

protocol SearchBakeryUseCase {
    func execute(_ request: SearchBakeryRequestDTO) async throws -> Page<Bakery>
}

final class SearchBakeryUseCaseImpl: SearchBakeryUseCase {
    private let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func execute(_ request: SearchBakeryRequestDTO) async throws -> Page<Bakery> {
        return try await repository.getSerachBakeries(request)
    }
}
