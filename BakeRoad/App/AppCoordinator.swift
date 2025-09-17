//
//  AppCoordinator.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Combine
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
    @Published var tokenExpiredMessage: String?
    @Published var mainCoordinator: MainCoordinator?
    
    let dependency: AppDependency = .shared
    private let sessionManager: SessionManager
    private var cancellables = Set<AnyCancellable>()

    init() {
        sessionManager = SessionManager.shared
        sessionManager.$tokenExpiredMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                self.tokenExpiredMessage = message

                guard message != nil else { return }
                self.mainCoordinator = nil
                self.route = .login
            }
            .store(in: &cancellables)
    }
    
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
        sessionManager.clearTokenExpired()
        ToastManager.show(message: "로그아웃되었습니다.")
    }
    
    func deleteAccount() {
        mainCoordinator = nil
        route = .login
        sessionManager.clearTokenExpired()
        ToastManager.show(message: "회원탈퇴가 완료되었습니다.")
    }

    func confirmTokenExpired() {
        sessionManager.clearTokenExpired()
    }
}
