//
//  AppViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Foundation
import KakaoSDKUser

enum AppState {
    case splash
    case login
//    case onboarding
//    case main
}

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .splash
    
    init() {
        checkAuth()
    }
    
    func checkAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let isLoggedIn = KeychainHelper.shared.load(forKey: "accessToken") != nil
//            self.appState = isLoggedIn ? .main : .login
        }
    }
    
    func login() {
        // 로그인 성공 후
        loginWithKakao { accessToken in
            
        }
    }
    
    func logout() {
        appState = .login
    }
}

extension AppViewModel {
    func loginWithKakao(completion: @escaping (String?) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let token = oauthToken?.accessToken {
                    completion(token)
                } else {
                    completion(nil)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let token = oauthToken?.accessToken {
                    completion(token)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
