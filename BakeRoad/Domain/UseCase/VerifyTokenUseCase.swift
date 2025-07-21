//
//  VerifyTokenUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 7/7/25.
//

import Foundation

protocol VerifyTokenUseCase {
    func verifyToken() async throws
}

final class VerifyTokenUseCaseImpl: VerifyTokenUseCase {
    private let repository: VerifyTokenRepository

    init(repository: VerifyTokenRepository) {
        self.repository = repository
    }

    func verifyToken() async throws {
        try await repository.verifyToken()
    }
}
