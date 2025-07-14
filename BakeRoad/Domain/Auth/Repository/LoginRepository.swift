//
//  LoginRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

protocol LoginRepository {
    func loginWithKakao() async throws -> Login
}
