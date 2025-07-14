//
//  TokenError.swift
//  BakeRoad
//
//  Created by 이현호 on 7/7/25.
//

import Foundation

enum TokenError: Error {
    case tokenNotFound
    case tokenExpired
    case invalidToken
}
