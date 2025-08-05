//
//  BakeRoadApp.swift
//  BakeRoad
//
//  Created by 이현호 on 6/5/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct BakeRoadApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    init() {
        KakaoSDK.initSDK(appKey: AppConstant.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        let _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
