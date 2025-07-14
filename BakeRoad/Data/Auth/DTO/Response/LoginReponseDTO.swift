//
//  LoginReponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

struct LoginReponseDTO: Decodable {
    let statusCode: Int
    let message: String
    let data: LoginData
    let token: Token
    
    struct LoginData: Decodable {
        let onboardingCompleted: String
        
        enum CodingKeys: String, CodingKey {
            case onboardingCompleted = "onboarding_completed"
        }
    }
    
    struct Token: Decodable {
        let accessToken: String
        let refreshToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
        }
    }
}
