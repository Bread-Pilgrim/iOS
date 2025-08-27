//
//  GetBreadReportUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

protocol GetBreadReportUseCase {
    func execute(_ requestDTO: BreadReportRequestDTO) async throws -> BreadReport
}

final class GetBreadReportUseCaseImpl: GetBreadReportUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(_ requestDTO: BreadReportRequestDTO) async throws -> BreadReport {
        return try await repository.getBreadReport(requestDTO)
    }
}
