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
    
    init(apiClient: APIClient,
         kakaoLoginService: KakaoLoginService) {
        self.apiClient = apiClient
        self.kakaoLoginService = kakaoLoginService
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
        
        return entity
    }
}
