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
        case main
    }
    
    @Published var route: Route?
    
    private let verifyTokenUseCase: VerifyTokenUseCase
    
    init(verifyTokenUseCase: VerifyTokenUseCase) {
        self.verifyTokenUseCase = verifyTokenUseCase
    }
    
    func onAppear() {
        Task {
            async let wait: Void = Task.sleep(nanoseconds: 1_000_000_000)
            async let verify: Void = verifyTokenUseCase.verifyToken()
            
            do {
                try await verify
                try await wait
                route = .main
            } catch {
                try? await wait
                route = .login
            }
        }
    }
}
