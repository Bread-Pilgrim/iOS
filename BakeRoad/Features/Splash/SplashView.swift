//
//  SplashView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Group {
            switch appViewModel.appState {
            case .splash:
                Image("splash")
                    .onAppear {
                        appViewModel.checkAuth()
                    }
                
            case .login:
                LoginView(appViewModel: _appViewModel)
                
//            case .main:
//                Image(systemName: "house")
//                
//            case .onboarding:
//                Text("Onboarding")
                
            }
        }
        .animation(.easeInOut, value: appViewModel.appState)
        .transition(.opacity)
        .environmentObject(appViewModel)
    }
}
