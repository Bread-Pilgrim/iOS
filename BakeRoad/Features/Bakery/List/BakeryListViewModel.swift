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

    private let fetcher: PageFetcher<Bakery>
    
    var onNavigateToBakeryDetail: ((Bakery) -> Void)?
    var onNavigateBack: (() -> Void)?

    init(
        filter: BakeryListFilter,
        getBakeryListUseCase: GetBakeryListUseCase
    ) {
        self.fetcher = PageFetcher<Bakery>(pageSize: 15) { page, size in
            let request = BakeryListRequestDTO(
                area_code: filter.areaCodes.map(String.init).joined(separator: ","),
                page_no: page,
                page_size: size
            )
            return try await getBakeryListUseCase.execute(filter.type, request: request)
        }

        Task { await loadInitial() }
    }

    func loadInitial() async {
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

@MainActor
final class PageFetcher<T: Identifiable>: ObservableObject where T.ID: Hashable {
    @Published private(set) var page: Page<T> = .empty
    private var currentPage = 1
    private let pageSize: Int
    private var isLoading = false
    private var lastTriggeredID: T.ID?

    private let fetchHandler: (_ page: Int, _ size: Int) async throws -> Page<T>

    init(
        pageSize: Int = 15,
        fetchHandler: @escaping (_ page: Int, _ size: Int) async throws -> Page<T>
    ) {
        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
    }

    func loadInitial() async throws {
        currentPage = 1
        lastTriggeredID = nil
        try await fetchPage(append: false)
    }

    func loadMoreIfNeeded(currentItem: T) async throws {
        guard page.hasNext, !isLoading else { return }
        guard lastTriggeredID != currentItem.id else { return }
        lastTriggeredID = currentItem.id

        if let index = page.items.firstIndex(where: { $0.id == currentItem.id }),
           index >= max(0, page.items.count - 5) {
            try await fetchPage(append: true)
        }
    }

    private func fetchPage(append: Bool) async throws {
        isLoading = true
        defer { isLoading = false }

        let nextPage = append ? currentPage + 1 : 1
        let result = try await fetchHandler(nextPage, pageSize)

        if append {
            page.items += result.items
            page.hasNext = result.hasNext
            currentPage = nextPage
        } else {
            page = result
            currentPage = 1
        }
    }
}
