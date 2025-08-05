//
//  UserOnboardRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

final class UserOnboardRepositoryImpl: UserOnboardRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func postUserOnboard(_ dto: UserOnboardRequestDTO) async throws {
        let request = APIRequest(
            path: UserEndpoint.onboarding,
            method: .post,
            parameters: dto
        )
        
        let _ = try await apiClient.request(request, responseType: EmptyPayload.self)
    }
}

struct EmptyPayload: Decodable {
    init(from decoder: Decoder) throws {
        // 어떤 형태가 오든( null / "" / {} / [] ) 조용히 무시
        _ = try? decoder.singleValueContainer()
        _ = try? decoder.container(keyedBy: DynamicCodingKeys.self)
        _ = try? decoder.unkeyedContainer()
    }
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String; init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int?; init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
    }
}
