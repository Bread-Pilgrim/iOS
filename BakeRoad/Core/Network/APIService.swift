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
    
    func request<T: Decodable, E: Decodable>(
        _ request: APIRequest,
        responseType: T.Type,
        extraType: E.Type
    ) async throws -> (data: T, extra: E?) {
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
        
        let baseResponse: BaseResponse<T, E> = try await withCheckedThrowingContinuation { continuation in
            dataTask.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(BaseResponse<T, E>.self, from: data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: APIError.decoding)
                    }
                case .failure(let afError):
                    if let data = response.data,
                       let decoded = try? JSONDecoder().decode(BaseResponse<T, E>.self, from: data) {
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
            if T.self == EmptyDTO.self, let emptyResult = EmptyDTO() as? T {
                return (emptyResult, nil)
            }
            throw APIError.emptyData
        }
        
        return (data, baseResponse.extra)
    }
    
    func requestMultipart<T: Decodable, E: Decodable>(
        _ request: APIRequest,
        imageData: [Data],
        responseType: T.Type,
        extraType: E.Type
    ) async throws -> (data: T, extra: E?) {
        let url = baseURL + request.path
        let method = HTTPMethod(rawValue: request.method.rawValue)
        let parameters = try request.parameters?.asDictionary()
        let session = request.customHeaders == nil ? self.session : self.sessionWithoutAuth
        
        var headers: HTTPHeaders = [:]
        
        if let customHeaders = request.customHeaders {
            customHeaders.forEach { key, value in
                headers.add(name: key, value: value)
            }
        }
        
        let baseResponse: BaseResponse<T, E> = try await withCheckedThrowingContinuation { continuation in
            session.upload(multipartFormData: { multipartFormData in
                if let parameters = parameters {
                    for (key, value) in parameters {
                        if let stringValue = String(describing: value).data(using: .utf8) {
                            multipartFormData.append(stringValue, withName: key)
                        }
                    }
                }
                
                for (index, data) in imageData.enumerated() {
                    multipartFormData.append(
                        data,
                        withName: "review_imgs",
                        fileName: "image_\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                }
                
            }, to: url, method: method, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(BaseResponse<T, E>.self, from: data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: APIError.decoding)
                    }
                case .failure(let afError):
                    if let data = response.data,
                       let decoded = try? JSONDecoder().decode(BaseResponse<T, E>.self, from: data) {
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
            if T.self == EmptyDTO.self, let emptyResult = EmptyDTO() as? T {
                return (emptyResult, nil)
            }
            throw APIError.emptyData
        }
        
        return (data, baseResponse.extra)
    }
}
