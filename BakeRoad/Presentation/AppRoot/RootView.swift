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
        case .main: splash
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
        OnboardingView(viewModel: OnboardingViewModel(
            getPreferOptionsUseCase: AppDependency.shared.getPreferOptionsUseCase
        ))
    }
}
