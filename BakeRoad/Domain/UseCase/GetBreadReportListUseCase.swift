//
//  GetBreadReportListUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

protocol GetBreadReportListUseCase {
    func execute(_ requestDTO: BreadReportListRequestDTO) async throws -> Page<BreadReportListItem>
}

final class GetBreadReportListUseCaseImpl: GetBreadReportListUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(_ requestDTO: BreadReportListRequestDTO) async throws -> Page<BreadReportListItem> {
        return try await repository.getBreadReportList(requestDTO)
    }
}
