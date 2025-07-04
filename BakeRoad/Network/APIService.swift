//
//  APIService.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Alamofire

public final class APIService {
    public static let shared = APIService()

    private let session: Session
    private let baseURL: String = AppConstant.baseURL

    private init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }

    public func request<T: Encodable, R: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        parameters: T? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) async throws -> R {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: [.accept("application/json")]
            )
            .validate()
            .responseDecodable(of: R.self) { response in
                switch response.result {
                case .success(let result):
                    continuation.resume(returning: result)

                case .failure:
                    if let data = response.data,
                       let apiError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        continuation.resume(throwing: APIError.serverError(message: apiError.message))
                    } else if response.response?.statusCode == 401 {
                        continuation.resume(throwing: APIError.unauthorized)
                    } else {
                        continuation.resume(throwing: APIError.unknown)
                    }
                }
            }
        }
    }
}

