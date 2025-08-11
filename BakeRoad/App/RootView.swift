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
        switch coordinator.route {
        case .splash: splash
        case .login: login
        case .onboarding: onboarding
        case .main: main
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
            userOnboardUseCase: AppDependency.shared.userOnboardUseCase
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
