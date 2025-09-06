//
//  TourRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

final class TourRepositoryImpl: TourRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getTourList(areaCodes: String, tourCatCodes: String) async throws -> [TourInfo] {
        let request = APIRequest(
            path: TourEndPoint.getTourList,
            method: .get,
            parameters: ["area_code" : areaCodes,
                         "tour_cat" : tourCatCodes]
        )
        
        let dto = try await apiClient.request(request, responseType: TourListResponseDTO.self)
        
        let entity = dto.map { $0.toEntity() }
        
        return entity
    }
    
    func getTourEvent(_ areaCodes: String) async throws -> EventPopup {
        let request = APIRequest(
            path: TourEndPoint.getTourEvent,
            method: .get,
            parameters: ["area_code" : areaCodes]
        )
        
        let dto = try await apiClient.request(request, responseType: TourEventResponseDTO.self)
        
        return dto.toEntity()
    }
}
