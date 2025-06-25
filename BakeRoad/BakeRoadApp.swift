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
        KakaoSDK.initSDK(appKey: "51502a87adb7922bc9b5e1fe7cc39c5a")
    }
    
    var body: some Scene {
        WindowGroup {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            ContentView().onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
