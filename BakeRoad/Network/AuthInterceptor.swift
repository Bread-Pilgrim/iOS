//
//  AuthInterceptor.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Foundation
import Alamofire

public final class AuthInterceptor: RequestInterceptor {
    public init() {}

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        if let token = KeychainHelper.shared.load(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "access-token")
        }

        completion(.success(request))
    }
}
