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
            async let wait: Void = Task.sleep(nanoseconds: 1_000_000_000)
            async let verify: Void = verifyTokenUseCase.verifyToken()
            
            do {
                try await verify
                try await wait
                route = tokenStore.onboardingCompleted ? .main : .onboarding
            } catch {
                try? await wait
                route = .login
            }
        }
    }
}
