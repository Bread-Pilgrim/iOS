//
//  GetBakeryMenuUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

protocol GetBakeryMenuUseCase {
    func execute(_ id: Int) async throws -> [BakeryMenu]
}

final class GetBakeryMenuUseCaseImpl: GetBakeryMenuUseCase {
    private let repository: BakeryRepository

    init(repository: BakeryRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws -> [BakeryMenu] {
        return try await repository.getBakeryMenus(id)
    }
}
