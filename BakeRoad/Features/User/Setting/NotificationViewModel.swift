//
//  NotificationViewModel.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import Foundation

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    var isExpanded: Bool = false
}

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = [
        NotificationItem(
            title: "성수동 인기 빵집 정보 업데이트 안내",
            description: "최근 성수동 지역의 인기 베이커리 정보를 새롭게 반영하였습니다.\n주말 방문 전, 최신 운영시간과 메뉴 정보를 확인해 주세요."
        ),
        NotificationItem(
            title: "리뷰 작성 이벤트 안내",
            description: "리뷰 작성해주시면 매우 땡스 어랏"
        ),
        NotificationItem(
            title: "일부 매장 운영시간 변경 안내",
            description: "일부 매장이 운영시간 레츠기릿 기리론"
        )
    ]
    
    // 네비게이션 콜백
    var onNavigateBack: (() -> Void)?
    
    func navigateBack() {
        onNavigateBack?()
    }
    
    func toggleExpanded(for id: UUID) {
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isExpanded.toggle()
        }
    }
}
