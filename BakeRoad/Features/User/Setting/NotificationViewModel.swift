//
//  NotificationViewModel.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import Foundation

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var errorMessage: String?
    
    private let getNoticeUseCase: GetNoticeUseCase
    
    var onNavigateBack: (() -> Void)?
    
    init(
        getNoticeUseCase: GetNoticeUseCase
    ) {
        self.getNoticeUseCase = getNoticeUseCase
        
        Task { await loadNotices() }
    }
    
    private func loadNotices() async {
        do {
            notices = try await getNoticeUseCase.execute()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
    
    func toggleExpanded(for notice: Notice) {
        if let index = notices.firstIndex(where: { $0 == notice }) {
            notices[index].isExpanded.toggle()
        }
    }
}
