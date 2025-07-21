//
//  BaseResponse.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T?
    let token: TokenDTO?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
        case token
    }
}

struct TokenDTO: Decodable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
