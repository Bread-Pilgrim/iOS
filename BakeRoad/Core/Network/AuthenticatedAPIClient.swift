//
//  AuthenticatedAPIClient.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ request: APIRequest, responseType: T.Type) async throws -> T
    func request<T: Decodable, E: Decodable>(_ request: APIRequest, responseType: T.Type, extraType: E.Type) async throws -> (data: T, extra: E?)
    func requestMultipart<T: Decodable>(_ request: APIRequest, imageData: [Data], responseType: T.Type) async throws -> T
    func requestMultipart<T: Decodable, E: Decodable>(_ request: APIRequest, imageData: [Data], responseType: T.Type, extraType: E.Type) async throws -> (data: T, extra: E?)
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
        
        let response = try await apiService.request(request, responseType: responseType, extraType: EmptyDTO.self)
        return response.data
    }
    
    func requestMultipart<T: Decodable>(_ request: APIRequest, imageData: [Data], responseType: T.Type) async throws -> T {
        if request.customHeaders == nil {
            guard let access = tokenStore.accessToken,
                  let refresh = tokenStore.refreshToken,
                  !access.isEmpty, !refresh.isEmpty else {
                throw TokenError.tokenNotFound
            }
        }
        
        let response = try await apiService.requestMultipart(request, imageData: imageData, responseType: responseType, extraType: EmptyDTO.self)
        return response.data
    }
    
    func request<T: Decodable, E: Decodable>(_ request: APIRequest, responseType: T.Type, extraType: E.Type) async throws -> (data: T, extra: E?) {
        if request.customHeaders == nil {
            guard let access = tokenStore.accessToken,
                  let refresh = tokenStore.refreshToken,
                  !access.isEmpty, !refresh.isEmpty else {
                throw TokenError.tokenNotFound
            }
        }
        
        return try await apiService.request(request, responseType: responseType, extraType: extraType)
    }
    
    func requestMultipart<T: Decodable, E: Decodable>(_ request: APIRequest, imageData: [Data], responseType: T.Type, extraType: E.Type) async throws -> (data: T, extra: E?) {
        if request.customHeaders == nil {
            guard let access = tokenStore.accessToken,
                  let refresh = tokenStore.refreshToken,
                  !access.isEmpty, !refresh.isEmpty else {
                throw TokenError.tokenNotFound
            }
        }
        
        return try await apiService.requestMultipart(request, imageData: imageData, responseType: responseType, extraType: extraType)
    }
}
