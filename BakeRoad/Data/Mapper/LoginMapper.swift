//
//  LoginMapper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

enum LoginMapper {
    static func map(from dto: LoginReponseDTO) -> Login {
        return Login(onboardingCompleted: dto.onboardingCompleted)
    }
}
