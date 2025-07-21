//
//  PreferenceRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

final class PreferenceRepositoryImpl: PreferenceRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPreferOptions() async throws -> [OnboardingStep: [Preference]] {
        let request = APIRequest(
            path: PreferenceEndpoint.preferenceOptions,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: GetPreferencesResponseDTO.self)
        
        return PreferenceMapper.map(from: dto)
    }
}
