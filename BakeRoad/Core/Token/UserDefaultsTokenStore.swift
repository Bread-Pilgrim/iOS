//
//  UserDefaultsTokenStore.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

final class UserDefaultsTokenStore: TokenStore, @unchecked Sendable {
    private let accessTokenKey = "access-token"
    private let refreshTokenKey = "refresh-token"
    private let onboardingCompletedKey = "onboarding_completed"
    private let userDefaults = UserDefaults.standard

    var accessToken: String? {
        get { userDefaults.string(forKey: accessTokenKey) }
        set {
            if let token = newValue {
                userDefaults.set(token, forKey: accessTokenKey)
            } else {
                userDefaults.removeObject(forKey: accessTokenKey)
            }
        }
    }

    var refreshToken: String? {
        get { userDefaults.string(forKey: refreshTokenKey) }
        set {
            if let token = newValue {
                userDefaults.set(token, forKey: refreshTokenKey)
            } else {
                userDefaults.removeObject(forKey: refreshTokenKey)
            }
        }
    }
    
    var onboardingCompleted: Bool {
        get { userDefaults.bool(forKey: onboardingCompletedKey) }
        set { userDefaults.set(newValue, forKey: onboardingCompletedKey) }
    }
}
