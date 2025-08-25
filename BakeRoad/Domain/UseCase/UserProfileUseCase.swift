//
//  UserProfileUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/25/25.
//

import Foundation

protocol UserProfileUseCase {
    func execute() async throws -> UserProfile
}

final class UserProfileUseCaseImpl: UserProfileUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfile {
        return try await repository.getUserProfile()
    }
}
