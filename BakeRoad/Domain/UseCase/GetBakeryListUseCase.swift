//
//  GetBakeryListUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

protocol GetBakeryListUseCase {
    func execute(_ type: BakeryType, request: BakeryListRequestDTO) async throws -> Page<Bakery>
}

final class GetBakeryListUseCaseImpl: GetBakeryListUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ type: BakeryType, request: BakeryListRequestDTO) async throws -> Page<Bakery> {
        return try await repository.getBakeryList(type, requestDTO: request)
    }
}
