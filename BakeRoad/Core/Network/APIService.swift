//
//  APIService.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Foundation
import Alamofire

final class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://fastapi-1015297428835.asia-northeast3.run.app"
    private let session: Session
    private let sessionWithoutAuth: Session
    private let tokenStore: TokenStore
    
    private init(tokenStore: TokenStore = UserDefaultsTokenStore()) {
        let interceptor = AuthInterceptor(tokenStore: tokenStore)
        self.session = Session(interceptor: interceptor, eventMonitors: [CURLLogger()])
        self.sessionWithoutAuth = Session(eventMonitors: [CURLLogger()])
        self.tokenStore = tokenStore
    }
    
    func request<T: Decodable>(
        _ request: APIRequest,
        responseType: T.Type
    ) async throws -> T {
        let url = baseURL + request.path
        let method = HTTPMethod(rawValue: request.method.rawValue)
        let parameters = try request.parameters?.asDictionary()
        let session = request.customHeaders == nil ? self.session : self.sessionWithoutAuth
        
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        if let customHeaders = request.customHeaders {
            customHeaders.forEach { key, value in
                headers.add(name: key, value: value)
            }
        }
        
        let dataTask = session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: request.method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: headers
        )
        
        let baseResponse: BaseResponse<T> = try await withCheckedThrowingContinuation { continuation in
            dataTask.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: APIError.decoding)
                    }
                case .failure(let afError):
                    if let data = response.data,
                       let decoded = try? JSONDecoder().decode(BaseResponse<T>.self, from: data) {
                        continuation.resume(
                            throwing: APIError.serverError(code: decoded.statusCode, message: decoded.message)
                        )
                    } else {
                        continuation.resume(throwing: APIError.network(afError))
                    }
                }
            }
        }
        
        if let token = baseResponse.token {
            tokenStore.accessToken = token.accessToken
            tokenStore.refreshToken = token.refreshToken
        }
        
        guard baseResponse.statusCode == 200 else {
            throw APIError.serverError(code: baseResponse.statusCode, message: baseResponse.message)
        }
        
        guard let data = baseResponse.data else {
            throw APIError.emptyData
        }
        
        return data
    }
}
