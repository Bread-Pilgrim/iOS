//
//  GetPreferOptionsUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

protocol GetPreferOptionsUseCase {
    func execute() async throws -> [OnboardingStep: [Preference]]
}

final class GetPreferOptionsUseCaseImpl: GetPreferOptionsUseCase {
    private let repository: PreferRepository

    init(repository: PreferRepository) {
        self.repository = repository
    }

    func execute() async throws -> [OnboardingStep: [Preference]] {
        return try await repository.getPreferOptions()
    }
}
