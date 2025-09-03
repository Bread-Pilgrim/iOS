//
//  UserRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

protocol UserRepository {
    func postUserOnboard(_ dto: UserOnboardRequestDTO) async throws
    func getUserPreference() async throws -> [OnboardingStep: [Preference]]
    func updateUserPreference(_ dto: UpdateUserPreferenceRequestDTO) async throws
    func getUserProfile() async throws -> UserProfile
    func getUserReview(_ requestDTO: UserReviewRequestDTO) async throws -> Page<UserReview>
    func getBreadReportList(_ requestDTO: BreadReportListRequestDTO) async throws -> Page<BreadReportListItem>
    func getBreadReport(_ requestDTO: BreadReportRequestDTO) async throws -> BreadReport
    func badgeRepresent(_ id: Int) async throws
    func badgeDerepresent(_ id: Int) async throws
}
