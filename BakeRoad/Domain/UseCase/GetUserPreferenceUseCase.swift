//
//  GetUserPreferenceUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/20/25.
//

import Foundation

protocol GetUserPreferenceUseCase {
    func execute() async throws -> [OnboardingStep: [Preference]]
}

final class GetUserPreferenceUseCaseImpl: GetUserPreferenceUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute() async throws -> [OnboardingStep: [Preference]] {
        return try await repository.getUserPreference()
    }
}
