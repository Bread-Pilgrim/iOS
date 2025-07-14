//
//  APIService.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Alamofire

final class APIService {
    static let shared = APIService()

    private let baseURL = "https://fastapi-1015297428835.asia-northeast3.run.app"
    private let session: Session

    private init() {
        let interceptor = AuthInterceptor()
        self.session = Session(interceptor: interceptor)
    }

    func request<T: Decodable>(
        _ request: APIRequest,
        responseType: T.Type
    ) async throws -> T {
        let url = baseURL + request.path
        let method = HTTPMethod(rawValue: request.method.rawValue)
        let parameters = try request.parameters?.asDictionary()

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
        .validate()

        let data = try await withCheckedThrowingContinuation { continuation in
            dataTask.responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

        return data
    }
}
