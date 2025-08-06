//
//  GetTourListUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

protocol GetTourListUseCase {
    func execute(areaCodes: String, tourCatCodes: String) async throws -> [TourInfo]
}

final class GetTourListUseCaseImpl: GetTourListUseCase {
    private let repository: TourRepository

    init(repository: TourRepository) {
        self.repository = repository
    }

    func execute(areaCodes: String, tourCatCodes: String) async throws -> [TourInfo] {
        try await repository.getTourList(areaCodes: areaCodes, tourCatCodes: tourCatCodes)
    }
}
