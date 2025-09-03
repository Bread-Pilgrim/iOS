//
//  BadgeListViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import Foundation

@MainActor
final class BadgeListViewModel: ObservableObject {
    @Published var badgeList: [Badge] = []
    @Published var representedBadge: Badge?
    @Published var selectedBadge: Badge?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let getBadgeListUseCase: GetBadgeListUseCase
    private let badgeRepresentUseCase: BadgeRepresentUseCase
    private let badgeDerepresentUseCase: BadgeDerepresentUseCase
    
    var onNavigateBack: (() -> Void)?
    
    init(
        getBadgeListUseCase: GetBadgeListUseCase,
        badgeRepresentUseCase: BadgeRepresentUseCase,
        badgeDerepresentUseCase: BadgeDerepresentUseCase
    ) {
        self.getBadgeListUseCase = getBadgeListUseCase
        self.badgeRepresentUseCase = badgeRepresentUseCase
        self.badgeDerepresentUseCase = badgeDerepresentUseCase
        
        Task { await loadBadgeList() }
    }
    
    private func loadBadgeList() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            badgeList = try await getBadgeListUseCase.execute()
            representedBadge = badgeList.first { $0.isRepresentative && $0.isEarned }
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    private func badgeRepresent(_ id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await badgeRepresentUseCase.execute(id)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    private func badgeDerepresent(_ id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await badgeDerepresentUseCase.execute(id)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func toggleBadgeRepresent(_ badge: Badge) async -> String {
        if badge.isRepresentative {
            await badgeDerepresent(badge.id)
            await loadBadgeList()
            return "대표뱃지가 해지되었습니다!"
        } else {
            await badgeRepresent(badge.id)
            await loadBadgeList()
            return "대표뱃지가 설정되었습니다!"
        }
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
}
