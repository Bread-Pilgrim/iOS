//
//  LoginRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

final class LoginRepositoryImpl: LoginRepository {
    private let apiClient: APIClient
    private let tokenStore: TokenStore
    private let kakaoLoginService: KakaoLoginService
    
    init(apiClient: APIClient,
         tokenStore: TokenStore,
         kakaoLoginService: KakaoLoginService) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.kakaoLoginService = kakaoLoginService
    }
    
    func loginWithKakao() async throws -> Login {
        let kakaoAccessToken = try await kakaoLoginService.loginAndGetAccessToken()
        
        let request = APIRequest(
            path: "/auth/login",
            method: .post,
            parameters: LoginRequestDTO(loginType: .kakao),
            customHeaders: ["access-token": kakaoAccessToken]
        )
        
        let dto = try await apiClient.request(request, responseType: LoginReponseDTO.self)
        
        tokenStore.accessToken = dto.token.accessToken
        tokenStore.refreshToken = dto.token.refreshToken
        
        let entity = LoginMapper.map(from: dto)
        
        return entity
    }
}
