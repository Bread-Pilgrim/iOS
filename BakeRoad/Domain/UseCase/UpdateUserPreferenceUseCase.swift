//
//  UpdateUserPreferenceUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/20/25.
//

import Foundation

protocol UpdateUserPreferenceUseCase {
    func execute(_ requestDTO: UpdateUserPreferenceRequestDTO) async throws
}

final class UpdateUserPreferenceUseCaseImpl: UpdateUserPreferenceUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(_ requestDTO: UpdateUserPreferenceRequestDTO) async throws {
        return try await repository.updateUserPreference(requestDTO)
    }
}
