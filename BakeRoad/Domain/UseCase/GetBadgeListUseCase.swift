//
//  GetBadgeListUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import Foundation

protocol GetBadgeListUseCase {
    func execute() async throws -> [Badge]
}

final class GetBadgeListUseCaseImpl: GetBadgeListUseCase {
    private let repository: BadgeRepository

    init(repository: BadgeRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Badge] {
        try await repository.getBadgeList()
    }
}
