//
//  SplashView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Image("splash")
            .onAppear {
                viewModel.onAppear()
            }
            .onChange(of: viewModel.route) {
                guard let route = viewModel.route else { return }
                switch route {
                case .main:
                    coordinator.showOnboarding()
                case .login:
                    coordinator.showLogin()
                }
            }
    }
}
