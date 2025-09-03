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
    
    func getUserReview(_ requestDTO: UserReviewRequestDTO) async throws -> Page<UserReview> {
        let request = APIRequest(
            path: UserEndpoint.getMyReviews,
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: UserReviewResponseDTO.self)
        
        return Page(items: dto.reviews.map { $0.toEntity() }, nextCursor: dto.nextCursor)
    }
    
    func getBreadReportList(_ requestDTO: BreadReportListRequestDTO) async throws -> Page<BreadReportListItem> {
        let request = APIRequest(
            path: UserEndpoint.breadReportList,
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: BreadReportListResponseDTO.self)
        
        return Page(items: dto.items.map { $0.toEntity() }, nextCursor: dto.nextCursor)
    }
    
    func getBreadReport(_ requestDTO: BreadReportRequestDTO) async throws -> BreadReport {
        let request = APIRequest(
            path: UserEndpoint.breadReport,
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: BreadReportResponseDTO.self)
        
        return dto.toEntity()
    }
    
    func badgeRepresent(_ id: Int) async throws {
        let request = APIRequest(
            path: UserEndpoint.badgeRepresent(id),
            method: .post
        )
        
        let _ = try await apiClient.request(request, responseType: EmptyDTO.self)
    }
    
    func badgeDerepresent(_ id: Int) async throws {
        let request = APIRequest(
            path: UserEndpoint.badgeDerepresent(id),
            method: .post
        )
        
        let _ = try await apiClient.request(request, responseType: EmptyDTO.self)
    }
}
