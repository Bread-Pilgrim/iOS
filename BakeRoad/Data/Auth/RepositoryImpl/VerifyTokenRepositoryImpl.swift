//
//  VerifyTokenRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

final class VerifyTokenRepositoryImpl: VerifyTokenRepository {
    private let apiClient: APIClient
    private let tokenStore: TokenStore
    
    init(
        apiClient: APIClient,
        tokenStore: TokenStore
    ) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
    }
    
    func verifyToken() async throws {
        let request = APIRequest(path: AuthPath.verifyToken, method: .post)
        let response = try await apiClient.request(request, responseType: VerifyTokenResponseDTO.self)
        
        if let token = response.token {
            tokenStore.accessToken = token.accessToken
            tokenStore.refreshToken = token.refreshToken
        }
    }
}
