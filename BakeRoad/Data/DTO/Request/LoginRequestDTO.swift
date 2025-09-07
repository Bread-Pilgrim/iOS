//
//  LoginRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

enum LoginType: String, Encodable {
    case KAKAO
    case APPLE
}

struct LoginRequestDTO: Encodable {
    let loginType: LoginType

    enum CodingKeys: String, CodingKey {
        case loginType = "login_type"
    }
}
