//
//  SessionManager.swift
//  BakeRoad
//
//  Created by 이현호 on 9/17/25.
//

import Foundation

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var tokenExpiredMessage: String?

    private let tokenStore: TokenStore

    private init(tokenStore: TokenStore = UserDefaultsTokenStore()) {
        self.tokenStore = tokenStore
    }

    func handleTokenExpired(message: String? = nil) {
        tokenStore.accessToken = nil
        tokenStore.refreshToken = nil
        tokenExpiredMessage = message ?? "로그인이 만료됐어요.\n보안을 위해 다시 로그인 해주세요🥹"
    }

    func clearTokenExpired() {
        tokenExpiredMessage = nil
    }
}
