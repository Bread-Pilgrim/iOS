//
//  LoginReponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

struct LoginReponseDTO: Decodable {
    let onboardingCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case onboardingCompleted = "onboarding_completed"
    }
}
