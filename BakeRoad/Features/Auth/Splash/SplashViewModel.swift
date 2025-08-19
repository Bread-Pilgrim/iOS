//
//  SplashViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    enum Route {
        case login
        case onboarding
        case main
    }
    
    @Published var route: Route?
    
    private let verifyTokenUseCase: VerifyTokenUseCase
    private let tokenStore: TokenStore
    
    init(
        verifyTokenUseCase: VerifyTokenUseCase,
        tokenStore: TokenStore = UserDefaultsTokenStore()
    ) {
        self.verifyTokenUseCase = verifyTokenUseCase
        self.tokenStore = tokenStore
    }
    
    func onAppear() {
        Task {
            do {
                try await verifyTokenUseCase.verifyToken()
                route = tokenStore.onboardingCompleted ? .main : .onboarding
            } catch {
                route = .login
            }
        }
    }
}
