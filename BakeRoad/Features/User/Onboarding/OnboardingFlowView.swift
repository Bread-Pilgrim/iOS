//
//  OnboardingFlowView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import SwiftUI

enum OnboardingRoute: Hashable {
    case nickname
}

struct OnboardingFlowView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var path: [OnboardingRoute] = []
    
    private let onboardingViewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.onboardingViewModel = viewModel
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            OnboardingView(viewModel: onboardingViewModel) {
                path.append(.nickname)
            }
            .navigationDestination(for: OnboardingRoute.self) { route in
                switch route {
                case .nickname:
                    NickNameView(viewModel: onboardingViewModel) {
                        coordinator.showMain()
                    }
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                path.removeLast()
                            } label: {
                                Image("arrowLeft")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
