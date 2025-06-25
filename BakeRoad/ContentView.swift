//
//  ContentView.swift
//  BakeRoad
//
//  Created by 이현호 on 6/5/25.
//

import SwiftUI

import KakaoSDKUser

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Button("", image: ImageResource(name: "kakao_login_medium_narrow", bundle: .main)) {
                KakaoLogin()
            }
        }
        .padding()
    }
    
    func kakaoLonginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
    
    func KakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 인증
            kakaoLonginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
}

#Preview {
    ContentView()
}
