//
//  VerifyTokenRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

final class VerifyTokenRepositoryImpl: VerifyTokenRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func verifyToken() async throws {
        let request = APIRequest(
            path: AuthEndpoint.verifyToken,
            method: .post
        )
        
        let _ = try await apiClient.request(request, responseType: VerifyTokenResponseDTO.self)
    }
}
