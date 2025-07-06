//
//  AuthInterceptor.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Foundation
import Alamofire

struct APIInterceptor: RequestInterceptor, Sendable {
    let accessToken: String?
    let refreshToken: String?

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "access-token")
        }
        if let refreshToken = refreshToken {
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "refresh-token")
        }
        completion(.success(request))
    }
}
