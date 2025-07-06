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
    init() {
        KakaoSDK.initSDK(appKey: AppConstant.kakaoAppKey)
    }
    
    @StateObject var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(appViewModel)
        }
    }
}
