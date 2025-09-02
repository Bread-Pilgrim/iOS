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
    
    var onNavigateBack: (() -> Void)?
    
    init(
        getBadgeListUseCase: GetBadgeListUseCase
    ) {
        self.getBadgeListUseCase = getBadgeListUseCase
        
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
    
    func navigateBack() {
        onNavigateBack?()
    }
}
