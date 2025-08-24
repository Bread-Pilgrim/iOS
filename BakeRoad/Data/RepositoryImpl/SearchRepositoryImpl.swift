//
//  SearchRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

final class SearchRepositoryImpl: SearchRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getSerachBakeries(_ requestDTO: SearchBakeryRequestDTO) async throws -> Page<Bakery> {
        let request = APIRequest(
            path: SearchEndPoint.searchBakeries,
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: SearchBakeryResponseDTO.self)
        
        let entity = dto.items.map { $0.toEntity() }
        
        return Page(items: entity, nextCursor: dto.nextCursor)
    }
}
