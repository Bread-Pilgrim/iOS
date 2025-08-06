//
//  BakeryRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

final class BakeryRepositoryImpl: BakeryRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getRecommendBakeries(_ type: RecommendBakeryType, areaCode: String) async throws -> [RecommendBakery] {
        let request = APIRequest(
            path: type.endpoint,
            method: .get,
            parameters: ["area_code": areaCode]
        )
        
        let dto = try await apiClient.request(request, responseType: BakeriesRecommendResponseDTO.self)
        
        let entity = dto.map { $0.toEntity() }
        
        return entity
    }
}
