//
//  VerifyTokenRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

protocol VerifyTokenRepository {
    func verifyToken() async throws
}
