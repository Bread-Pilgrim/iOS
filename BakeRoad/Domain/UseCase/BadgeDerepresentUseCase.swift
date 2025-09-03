//
//  BadgeDerepresentUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/2/25.
//

import Foundation

protocol BadgeDerepresentUseCase {
    func execute(_ id: Int) async throws
}

final class BadgeDerepresentUseCaseImpl: BadgeDerepresentUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(_ id: Int) async throws {
        return try await repository.badgeDerepresent(id)
    }
}
