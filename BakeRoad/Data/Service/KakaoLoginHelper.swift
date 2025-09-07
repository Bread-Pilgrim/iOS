//
//  KakaoLoginHelper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import KakaoSDKUser

protocol KakaoLoginService {
    func loginAndGetAccessToken() async throws -> String
    func logout() async throws
    func withdraw() async throws
}

enum KakaoLoginError: Error {
    case unknown
    case cancelled
    case noAccessToken
    case logoutFailed
    case withdrawFailed
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
    
    func logout() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func withdraw() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.unlink { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
