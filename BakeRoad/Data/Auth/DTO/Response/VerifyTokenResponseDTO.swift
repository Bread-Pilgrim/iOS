//
//  VerifyTokenResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

struct VerifyTokenResponseDTO: Decodable {
    let statusCode: Int
    let message: String
    let data: String
    let token: AuthTokenDTO?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
        case token
    }
}

struct AuthTokenDTO: Decodable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
