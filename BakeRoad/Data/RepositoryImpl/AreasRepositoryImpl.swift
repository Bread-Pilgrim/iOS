//
//  AreasRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

final class AreasRepositoryImpl: AreasRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getAreaList() async throws -> [Area] {
        let request = APIRequest(
            path: AreasEndpoint.getAreas,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: [AreasReponseDTO].self)
        
        let entity = dto.map { AreasMapper.map(from: $0) }

        return entity
    }
}
