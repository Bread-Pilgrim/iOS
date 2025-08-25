//
//  NotificationViewModel.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import Foundation

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var isServiceUpdateEnabled = true
    @Published var isReviewEventEnabled = false
    @Published var isOperationTimeEnabled = true
    
    // 네비게이션 콜백
    var onNavigateBack: (() -> Void)?
    
    func navigateBack() {
        onNavigateBack?()
    }
}