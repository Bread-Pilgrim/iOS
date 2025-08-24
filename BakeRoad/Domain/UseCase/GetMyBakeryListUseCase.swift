//
//  GetMyBakeryListUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/24/25.
//

import Foundation

protocol GetMyBakeryListUseCase {
    func execute(_ type: MyBakeryType, request: BakeryMyListRequestDTO) async throws -> Page<Bakery>
}

final class GetMyBakeryListUseCaseImpl: GetMyBakeryListUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ type: MyBakeryType, request: BakeryMyListRequestDTO) async throws -> Page<Bakery> {
        return try await repository.getMyBakeryList(type, requestDTO: request)
    }
}
