//
//  AppDependency.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

final class AppDependency {
    static let shared = AppDependency()
    
    // MARK: - Network
    let tokenStore: TokenStore
    let authenticatedClient: APIClient
    let kakaoLoginService: KakaoLoginService
    
    // MARK: - Repositories
    let loginRepository: LoginRepository
    let verifyTokenRepository: VerifyTokenRepository
    let preferenceRepository: PreferenceRepository
    
    // MARK: - UseCases
    let loginUseCase: LoginUseCase
    let verifyTokenUseCase: VerifyTokenUseCase
    let getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase
    
    private init() {
        // 네트워크/토큰 관련
        self.tokenStore = KeychainTokenStore()
        let apiService = APIService.shared
        
        self.authenticatedClient = AuthenticatedAPIClientImpl(apiService: apiService, tokenStore: tokenStore)
        self.kakaoLoginService = KakaoLoginHelper()
        
        // Repository
        self.loginRepository = LoginRepositoryImpl(
            apiClient: authenticatedClient,
            kakaoLoginService: kakaoLoginService
        )
        
        self.verifyTokenRepository = VerifyTokenRepositoryImpl(
            apiClient: authenticatedClient
        )
        
        self.preferenceRepository = PreferenceRepositoryImpl(apiClient: authenticatedClient)
        
        // UseCase
        self.loginUseCase = LoginUseCaseImpl(repository: loginRepository)
        self.verifyTokenUseCase = VerifyTokenUseCaseImpl(repository: verifyTokenRepository)
        self.getPreferenceOptionsUseCase = GetPreferenceOptionsUseCaseImpl(repository: preferenceRepository)
    }
}
