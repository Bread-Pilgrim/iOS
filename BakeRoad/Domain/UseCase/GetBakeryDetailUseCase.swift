//
//  GetBakeryDetailUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

protocol GetBakeryDetailUseCase {
    func execute(_ id: Int) async throws -> BakeryDetail
}

final class GetBakeryDetailUseCaseImpl: GetBakeryDetailUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws -> BakeryDetail {
        return try await repository.getBakeryDetail(id)
    }
}
