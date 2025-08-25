//
//  UserRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
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
        
        let _ = try await apiClient.request(request, responseType: EmptyDTO.self)
    }
    
    func getUserPreference() async throws -> [OnboardingStep: [Preference]] {
        let request = APIRequest(
            path: UserEndpoint.userPreference,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: GetUserPreferencesResponseDTO.self)
        
        return PreferenceMapper.map(from: dto)
    }
    
    func updateUserPreference(_ dto: UpdateUserPreferenceRequestDTO) async throws {
        let request = APIRequest(
            path: UserEndpoint.userPreference,
            method: .patch,
            parameters: dto
        )
        
        let _ = try await apiClient.request(request, responseType: EmptyDTO.self)
    }
    
    func getUserProfile() async throws -> UserProfile {
        let request = APIRequest(
            path: UserEndpoint.userProfile,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: UserProfileResponseDTO.self)
        
        return dto.toEntity()
    }
}
