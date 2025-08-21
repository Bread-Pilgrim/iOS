//
//  PageFetcher.swift
//  BakeRoad
//
//  Created by 이현호 on 8/19/25.
//

import Foundation

@MainActor
final class PageFetcher<T: Identifiable>: ObservableObject where T.ID: Hashable {
    @Published private(set) var page: Page<T> = .empty
    private let pageSize: Int
    private var isLoading = false
    private var lastTriggeredID: T.ID?

    private let fetchHandler: (_ cursor: String, _ size: Int) async throws -> Page<T>

    init(
        pageSize: Int = 15,
        fetchHandler: @escaping (_ cursor: String, _ size: Int) async throws -> Page<T>
    ) {
        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
    }

    func loadInitial() async throws {
        lastTriggeredID = nil
        try await fetchPage(append: false)
    }

    func loadMoreIfNeeded(currentItem: T) async throws {
        guard page.hasNext, !isLoading else { return }
        guard lastTriggeredID != currentItem.id else { return }
        
        if let index = page.items.firstIndex(where: { $0.id == currentItem.id }),
           index >= max(0, page.items.count - 3) {
            lastTriggeredID = currentItem.id
            try await fetchPage(append: true)
        }
    }
    
    // 스크롤 기반 페이징을 위한 새로운 메서드
    func loadMoreIfScrolledToEnd() async throws {
        guard page.hasNext, !isLoading else { return }
        try await fetchPage(append: true)
    }

    private func fetchPage(append: Bool) async throws {
        isLoading = true
        defer { isLoading = false }

        let cursor = append ? (page.nextCursor ?? "0") : "0"  // 최초 요청 시 "0" 사용
        let result = try await fetchHandler(cursor, pageSize)

        if append {
            page.items += result.items
            page.nextCursor = result.nextCursor
        } else {
            page = result
        }
    }
}
