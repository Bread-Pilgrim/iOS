//
//  LoginViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase
    private let coordinator: AppCoordinator

    @Published var isLoading = false

    init(loginUseCase: LoginUseCase, coordinator: AppCoordinator) {
        self.loginUseCase = loginUseCase
        self.coordinator = coordinator
    }

    func login() {
        Task {
            isLoading = true

            do {
                let loginResult = try await loginUseCase.execute()
                isLoading = false

                if loginResult.onboardingCompleted {
                    coordinator.route = .main
                } else {
                    coordinator.route = .onboarding
                }

            } catch {
                isLoading = false
            }
        }
    }
}
