//
//  KeychainTokenStore.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

final class KeychainTokenStore: TokenStore, @unchecked Sendable {
    private let accessTokenKey = "access-token"
    private let refreshTokenKey = "refresh-token"

    var accessToken: String? {
        get { KeychainHelper.load(key: accessTokenKey) }
        set {
            if let token = newValue {
                KeychainHelper.save(token, key: accessTokenKey)
            } else {
                KeychainHelper.delete(key: accessTokenKey)
            }
        }
    }

    var refreshToken: String? {
        get { KeychainHelper.load(key: refreshTokenKey) }
        set {
            if let token = newValue {
                KeychainHelper.save(token, key: refreshTokenKey)
            } else {
                KeychainHelper.delete(key: refreshTokenKey)
            }
        }
    }
}
