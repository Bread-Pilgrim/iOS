//
//  LoginViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation
import AuthenticationServices

@MainActor
final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase
    private let coordinator: AppCoordinator
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(loginUseCase: LoginUseCase, coordinator: AppCoordinator) {
        self.loginUseCase = loginUseCase
        self.coordinator = coordinator
    }
    
    func login(_ token: String? = nil) {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let loginResult = try await loginUseCase.execute(token)
                
                if loginResult.onboardingCompleted {
                    coordinator.route = .main
                } else {
                    coordinator.route = .onboarding
                }
            } catch let APIError.serverError(_, message) {
                errorMessage = message
            } catch {
                errorMessage = "잠시 후 다시 시도해주세요."
            }
        }
    }
    
    func loginWithApple(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
               let tokenData = appleIDCredential.identityToken,
               let tokenString = String(data: tokenData, encoding: .utf8) {
                login(tokenString)
            }
        case .failure(_):
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
}
