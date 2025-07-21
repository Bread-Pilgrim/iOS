//
//  LoginUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

protocol LoginUseCase {
    func execute() async throws -> Login
}

final class LoginUseCaseImpl: LoginUseCase {
    private let repository: LoginRepository

    init(repository: LoginRepository) {
        self.repository = repository
    }

    func execute() async throws -> Login {
        return try await repository.loginWithKakao()
    }
}
