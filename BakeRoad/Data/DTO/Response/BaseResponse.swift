//
//  BaseResponse.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

struct BaseResponse<T: Decodable, E: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T?
    let errorUseCase: String?
    let token: TokenDTO?
    let extra: E?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
        case errorUseCase = "error_usecase"
        case token
        case extra
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
