//
//  LoginRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

final class LoginRepositoryImpl: LoginRepository {
    private let apiClient: APIClient
    private let kakaoLoginService: KakaoLoginService
    private let tokenStore: TokenStore
    
    init(
        apiClient: APIClient,
        kakaoLoginService: KakaoLoginService,
        tokenStore: TokenStore = UserDefaultsTokenStore()
    ) {
        self.apiClient = apiClient
        self.kakaoLoginService = kakaoLoginService
        self.tokenStore = tokenStore
    }
    
    func loginWithKakao() async throws -> Login {
        let kakaoAccessToken = try await kakaoLoginService.loginAndGetAccessToken()
        
        let request = APIRequest(
            path: AuthEndpoint.login,
            method: .post,
            parameters: LoginRequestDTO(loginType: .KAKAO),
            customHeaders: ["access-token": kakaoAccessToken]
        )
        
        let dto = try await apiClient.request(request, responseType: LoginReponseDTO.self)
        
        let entity = LoginMapper.map(from: dto)
        
        tokenStore.onboardingCompleted = entity.onboardingCompleted
        
        return entity
    }
    
    func loginWithApple(_ accessToken: String) async throws -> Login {
        let request = APIRequest(
            path: AuthEndpoint.login,
            method: .post,
            parameters: LoginRequestDTO(loginType: .APPLE),
            customHeaders: ["access-token": accessToken]
        )
        
        let dto = try await apiClient.request(request, responseType: LoginReponseDTO.self)
        
        let entity = LoginMapper.map(from: dto)
        
        tokenStore.onboardingCompleted = entity.onboardingCompleted
        
        return entity
    }
}
