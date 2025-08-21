//
//  BakeryListViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

@MainActor
final class BakeryListViewModel: ObservableObject {
    @Published var bakeries: [Bakery] = []
    @Published var hasNext: Bool = false
    @Published var errorMessage: String?
    @Published var isLoadingMore = false
    @Published var isLoading = false

    private let fetcher: PageFetcher<Bakery>
    
    var onNavigateToBakeryDetail: ((Bakery) -> Void)?
    var onNavigateBack: (() -> Void)?

    init(
        filter: BakeryListFilter,
        getBakeryListUseCase: GetBakeryListUseCase
    ) {
        self.fetcher = PageFetcher<Bakery>(pageSize: 15) { cursor, size in
            let request = BakeryListRequestDTO(
                area_code: filter.areaCodes.map(String.init).joined(separator: ","),
                cursor_value: cursor,
                page_size: size
            )
            return try await getBakeryListUseCase.execute(filter.type, request: request)
        }

        Task { await loadInitial() }
    }

    func loadInitial() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await fetcher.loadInitial()
            syncState()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }

    func loadMoreIfNeeded(currentItem: Bakery) async {
        do {
            try await fetcher.loadMoreIfNeeded(currentItem: currentItem)
            syncState()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    // 스크롤 기반 페이징
    func loadMoreOnScroll() async {
        guard !isLoadingMore, hasNext else { return }
        
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            try await fetcher.loadMoreIfScrolledToEnd()
            syncState()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }

    private func syncState() {
        bakeries = fetcher.page.items
        hasNext = fetcher.page.hasNext
    }
    
    func didTapBakery(_ bakery: Bakery) {
        onNavigateToBakeryDetail?(bakery)
    }
    
    func didTapBackButton() {
        onNavigateBack?()
    }
}
