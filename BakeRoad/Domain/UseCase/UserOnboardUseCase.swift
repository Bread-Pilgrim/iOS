//
//  UserOnboardUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

protocol UserOnboardUseCase {
    func execute(_ dto: UserOnboardRequestDTO) async throws
}

final class UserOnboardUseCaseImpl: UserOnboardUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(_ dto: UserOnboardRequestDTO) async throws {
        try await repository.postUserOnboard(dto)
    }
}
