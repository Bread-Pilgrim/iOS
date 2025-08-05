//
//  AuthenticatedAPIClient.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ request: APIRequest, responseType: T.Type) async throws -> T
}

final class AuthenticatedAPIClientImpl: APIClient {
    private let apiService: APIService
    private let tokenStore: TokenStore
    
    init(apiService: APIService = .shared, tokenStore: TokenStore = UserDefaultsTokenStore()) {
        self.apiService = apiService
        self.tokenStore = tokenStore
    }
    
    func request<T: Decodable>(_ request: APIRequest, responseType: T.Type) async throws -> T {
        if request.customHeaders == nil {
            guard let access = tokenStore.accessToken,
                  let refresh = tokenStore.refreshToken,
                  !access.isEmpty, !refresh.isEmpty else {
                throw TokenError.tokenNotFound
            }
        }
        
        return try await apiService.request(request, responseType: responseType)
    }
}
