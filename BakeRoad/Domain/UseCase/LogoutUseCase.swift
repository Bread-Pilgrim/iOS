//
//  LogoutUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/7/25.
//

import Foundation

protocol LogoutUseCase {
    func execute() async throws
}

final class LogoutUseCaseImpl: LogoutUseCase {
    private let repository: LoginRepository
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        return try await repository.logout()
    }
}
