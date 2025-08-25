//
//  UserInfoViewModel.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import Foundation

@MainActor
class UserInfoViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoadingProfile = false
    @Published var errorMessage: String?
    
    // 네비게이션 콜백들
    var onNavigateToSettings: (() -> Void)?
    var onNavigateToBadgeSettings: (() -> Void)?
    var onNavigateToReviews: (() -> Void)?
    var onNavigateToReceivedBreadges: (() -> Void)?
    var onNavigateToEarnings: (() -> Void)?
    var onNavigateToPreferenceChange: (() -> Void)?
    
    private let userProfileUseCase: UserProfileUseCase
    
    init(userProfileUseCase: UserProfileUseCase) {
        self.userProfileUseCase = userProfileUseCase
        
        Task { await loadUserProfile() }
    }
    
    private func loadUserProfile() async {
        isLoadingProfile = true
        defer { isLoadingProfile = false }
        
        do {
            userProfile = try await userProfileUseCase.execute()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "사용자 정보를 불러올 수 없습니다."
        }
    }
    
    func navigateToSettings() {
        onNavigateToSettings?()
    }
    
    func navigateToBadgeSettings() {
        onNavigateToBadgeSettings?()
    }
    
    func navigateToEarnings() {
        onNavigateToEarnings?()
    }
    
    func navigateToReceivedBreadges() {
        onNavigateToReceivedBreadges?()
    }
    
    func navigateToMyReviews() {
        onNavigateToReviews?()
    }
    
    func navigateToPreferenceChange() {
        onNavigateToPreferenceChange?()
    }
}
