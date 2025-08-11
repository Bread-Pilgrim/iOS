//
//  UserOnboardRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

final class UserOnboardRepositoryImpl: UserOnboardRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func postUserOnboard(_ dto: UserOnboardRequestDTO) async throws {
        let request = APIRequest(
            path: UserEndpoint.onboarding,
            method: .post,
            parameters: dto
        )
        
        let _ = try await apiClient.request(request, responseType: EmptyDTO.self)
    }
}
