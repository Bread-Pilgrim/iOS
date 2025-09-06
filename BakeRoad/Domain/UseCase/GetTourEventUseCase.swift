//
//  GetTourEventUseCase.swift
//  BakeRoad
//
//  Created by 이현호 on 9/4/25.
//

import Foundation

protocol GetTourEventUseCase {
    func execute(_ areaCodes: String) async throws -> EventPopup
}

final class GetTourEventUseCaseImpl: GetTourEventUseCase {
    private let repository: TourRepository
    
    init(repository: TourRepository) {
        self.repository = repository
    }
    
    func execute(_ areaCodes: String) async throws -> EventPopup {
        try await repository.getTourEvent(areaCodes)
    }
}
