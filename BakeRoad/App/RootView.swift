//
//  RootView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            switch coordinator.route {
            case .splash: splash
            case .login: login
            case .onboarding: onboarding
            case .main: main
            }
            
            ToastOverlayView()
                .environmentObject(ToastManager.shared)
                .padding(.horizontal, 28)
                .padding(.bottom, 16)
        }
        .overlay {
            if let message = coordinator.tokenExpiredMessage {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .overlay {
                        BakeRoadAlert(
                            message: message,
                            primaryAction: AlertAction(title: "확인") {
                                coordinator.confirmTokenExpired()
                            },
                            layout: .horizontal
                        )
                    }
            }
        }
    }
}

extension RootView {
    private var splash: some View {
        SplashView(viewModel: SplashViewModel(
            verifyTokenUseCase: AppDependency.shared.verifyTokenUseCase
        ))
    }
    
    private var login: some View {
        LoginView(viewModel: LoginViewModel(
            loginUseCase: AppDependency.shared.loginUseCase,
            coordinator: coordinator
        ))
    }
    
    private var onboarding: some View {
        OnboardingFlowView(viewModel: OnboardingViewModel(
            getPreferenceOptionsUseCase: AppDependency.shared.getPreferenceOptionsUseCase,
            userOnboardUseCase: AppDependency.shared.userOnboardUseCase,
            getUserPreferenceUseCase: AppDependency.shared.getUserPreferenceUseCase,
            updateUserPreferenceUseCase: AppDependency.shared.updateUserPreferenceUseCase
        ))
    }
    
    private var main: some View {
        Group {
            if let mainCoor = coordinator.mainCoordinator {
                MainView()
                    .environmentObject(mainCoor)
            } else {
                Color.clear.onAppear { coordinator.showMain() }
            }
        }
    }
}
