//
//  AppCoordinator.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    enum Route {
        case splash
        case login
        case onboarding
        case main
    }
    
    @Published var route: Route = .splash
    
    @Published var mainCoordinator: MainCoordinator?
    
    let dependency: AppDependency = .shared
    
    func showLogin() {
        route = .login
    }
    
    func showOnboarding() {
        route = .onboarding
    }
    
    func showMain() {
        mainCoordinator = MainCoordinator(dependency: dependency)
        route = .main
    }
}
