//
//  PreferRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

final class PreferRepositoryImpl: PreferRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPreferOptions() async throws -> [OnboardingStep: [Preference]] {
        let request = APIRequest(path: PreferPath.preferOptions, method: .get)
        let dto = try await apiClient.request(request, responseType: PreferResponseDTO.self)
        return PreferMapper.map(from: dto)
    }
}
