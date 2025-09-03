//
//  GetNoticeUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

protocol GetNoticeUseCase {
    func execute() async throws -> [Notice]
}

final class GetNoticeUseCaseImpl: GetNoticeUseCase {
    private let repository: NoticeRepository

    init(repository: NoticeRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Notice] {
        try await repository.getNotice()
    }
}

