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
    
    func showMain(with badges: [Badge]? = nil) {
        mainCoordinator = MainCoordinator(dependency: dependency, appCoordinator: self, badges: badges)
        route = .main
    }
    
    func logout() {
        mainCoordinator = nil
        route = .login
        ToastManager.show(message: "로그아웃되었습니다.")
    }
    
    func deleteAccount() {
        mainCoordinator = nil
        route = .login
        ToastManager.show(message: "회원탈퇴가 완료되었습니다.")
    }
}
