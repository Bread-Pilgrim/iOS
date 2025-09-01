//
//  BadgeRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import Foundation

final class BadgeRepositoryImpl: BadgeRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getBadgeList() async throws -> [Badge] {
        let request = APIRequest(
            path: BadgeEndpoint.getBadges,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: [BadgeResponseDTO].self)
        
        let entity = dto.map { $0.toEntity() }

        return entity
    }
}
