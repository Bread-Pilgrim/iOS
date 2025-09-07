//
//  TokenStore.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

protocol TokenStore: AnyObject, Sendable {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var onboardingCompleted: Bool { get set }
    var loginType: LoginType? { get set }
}
