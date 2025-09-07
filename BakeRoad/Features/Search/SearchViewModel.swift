//
//  SearchViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var recentSearches: [RecentSearch] = []
    @Published var recentBakeries: [RecommendBakery] = []
    @Published var searchResults: [Bakery] = []
    @Published var nextCursor: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // 검색 상태 관리
    @Published var currentSearchText: String = ""
    @Published var hasPerformedSearch: Bool = false
    @Published var isSearchFocused: Bool = false
    
    private let recentSearchManager = RecentSearchManager()
    private let searchBakeryUseCase: SearchBakeryUseCase
    private let recentBakeryUseCase: RecentBakeryUseCase
    private let deleteRecentBakeryUseCase: DeleteRecentBakeryUseCase
    
    var onNavigateToBakeryDetail: ((BakeryDetailFilter) -> Void)?
    
    init (
        searchBakeryUseCase: SearchBakeryUseCase,
        recentBakeryUseCase: RecentBakeryUseCase,
        deleteRecentBakeryUseCase: DeleteRecentBakeryUseCase
    ) {
        self.searchBakeryUseCase = searchBakeryUseCase
        self.recentBakeryUseCase = recentBakeryUseCase
        self.deleteRecentBakeryUseCase = deleteRecentBakeryUseCase
        
        Task { await loadInitial() }
    }
    
    private func loadInitial() async {
        Task {
            await loadRecentBakery()
            recentSearches = recentSearchManager.getRecentSearches()
        }
    }
    
    func loadRecentSearches() {
        recentSearches = recentSearchManager.getRecentSearches()
    }
    
    func loadRecentBakery() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            recentBakeries = try await recentBakeryUseCase.execute()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func search(_ searchText: String) async {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // 검색 상태 업데이트
        currentSearchText = trimmedText
        isSearchFocused = false
        hasPerformedSearch = true
        
        // 페이징 상태 초기화
        nextCursor = nil
        searchResults = []
        
        // 최근 검색어에 추가
        recentSearchManager.addRecentSearch(trimmedText)
        loadRecentSearches()
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = SearchBakeryRequestDTO(
                keyword: trimmedText,
                cursor: "0",
                pageSize: 20
            )
            
            let response = try await searchBakeryUseCase.execute(request)
            searchResults = response.items
            nextCursor = response.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func loadMoreResults() async {
        guard !isLoading,
              let nextCursor = nextCursor else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = SearchBakeryRequestDTO(
                keyword: currentSearchText,
                cursor: nextCursor,
                pageSize: 20
            )
            
            let response = try await searchBakeryUseCase.execute(request)
            searchResults.append(contentsOf: response.items)
            self.nextCursor = response.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func removeRecentSearch(_ searchId: UUID) {
        recentSearchManager.removeRecentSearch(searchId)
        loadRecentSearches()
    }
    
    func clearAllRecentSearches() {
        recentSearchManager.clearAllRecentSearches()
        loadRecentSearches()
    }
    
    func cancelSearch() {
        currentSearchText = ""
        hasPerformedSearch = false
        isSearchFocused = false
    }
    
    func clearAllRecentBakeries() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await deleteRecentBakeryUseCase.execute()
            recentBakeries.removeAll()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func didTapBakery(bakeryId: Int, areaCode: Int) {
        let filter = BakeryDetailFilter(
            bakeryId: bakeryId,
            areaCodes: [areaCode],
            tourCatCodes: CategoryManager.shared.selectedCategoryCodes
        )
        onNavigateToBakeryDetail?(filter)
    }
}
