//
//  DeleteAccountUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/7/25.
//

import Foundation

protocol DeleteAccountUseCase {
    func execute() async throws
}

final class DeleteAccountUseCaseImpl: DeleteAccountUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        return try await repository.deleteAccount()
    }
}

