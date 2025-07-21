//
//  GetAreaListUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

protocol GetAreaListUseCase {
    func execute() async throws -> [Area]
}

final class GetAreaListUseCaseImpl: GetAreaListUseCase {
    private let repository: AreasRepository

    init(repository: AreasRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Area] {
        try await repository.getAreaList()
    }
}
