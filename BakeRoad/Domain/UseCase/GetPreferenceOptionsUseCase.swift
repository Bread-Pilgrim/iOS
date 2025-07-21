//
//  GetPreferenceOptionsUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

protocol GetPreferenceOptionsUseCase {
    func execute() async throws -> [OnboardingStep: [Preference]]
}

final class GetPreferenceOptionsUseCaseImpl: GetPreferenceOptionsUseCase {
    private let repository: PreferenceRepository

    init(repository: PreferenceRepository) {
        self.repository = repository
    }

    func execute() async throws -> [OnboardingStep: [Preference]] {
        return try await repository.getPreferOptions()
    }
}
