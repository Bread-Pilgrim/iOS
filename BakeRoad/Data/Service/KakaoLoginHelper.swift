//
//  KakaoLoginHelper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import KakaoSDKUser

protocol KakaoLoginService {
    func loginAndGetAccessToken() async throws -> String
}

enum KakaoLoginError: Error {
    case unknown
    case cancelled
    case noAccessToken
}

final class KakaoLoginHelper: KakaoLoginService {
    func loginAndGetAccessToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let token = oauthToken?.accessToken {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: error ?? KakaoLoginError.noAccessToken)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let token = oauthToken?.accessToken {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: error ?? KakaoLoginError.noAccessToken)
                    }
                }
            }
        }
    }
}
