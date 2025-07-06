//
//  AuthInterceptor.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    private let tokenStore: TokenStore = KeychainTokenStore() // 주입 가능

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let accessToken = tokenStore.accessToken {
            request.setValue(accessToken, forHTTPHeaderField: "access-token")
        }
        if let refreshToken = tokenStore.refreshToken {
            request.setValue(refreshToken, forHTTPHeaderField: "refresh-token")
        }
        completion(.success(request))
    }
}
