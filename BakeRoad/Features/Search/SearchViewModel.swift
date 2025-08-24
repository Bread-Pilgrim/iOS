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
    @Published var recentBakeries: [Bakery] = []
    @Published var searchResults: [Bakery] = []
    @Published var isLoadingRecentBakeries = false
    @Published var isLoadingSearch = false
    @Published var errorMessage: String?
    
    // 검색 상태 관리
    @Published var currentSearchText: String = ""
    @Published var hasPerformedSearch: Bool = false
    @Published var isSearchFocused: Bool = false
    
    private let recentSearchManager = RecentSearchManager()
    private let searchBakeryUseCase: SearchBakeryUseCase
    
    var onNavigateToBakeryDetail: ((BakeryDetailFilter) -> Void)?
    
    init(searchBakeryUseCase: SearchBakeryUseCase) {
        self.searchBakeryUseCase = searchBakeryUseCase
        
        Task { await loadInitial() }
    }
    
    private func loadInitial() async {
        recentSearches = recentSearchManager.getRecentSearches()
    }
    
    func loadRecentSearches() {
        recentSearches = recentSearchManager.getRecentSearches()
    }
    
    func search(_ searchText: String) async {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // 검색 상태 업데이트
        currentSearchText = trimmedText
        hasPerformedSearch = true
        isSearchFocused = false
        
        // 최근 검색어에 추가
        recentSearchManager.addRecentSearch(trimmedText)
        loadRecentSearches()
        
        isLoadingSearch = true
        defer { isLoadingSearch = false }
        
        do {
            let request = SearchBakeryRequestDTO(
                keyword: trimmedText,
                cursor: "0",
                pageSize: 20
            )
            
            let response = try await searchBakeryUseCase.execute(request)
            searchResults = response.items
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "검색 결과를 불러올 수 없습니다."
        }
    }
    
    func selectRecentSearch(_ searchText: String) async {
        await search(searchText)
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
    
    func clearAllRecentBakeries() {
        recentBakeries.removeAll()
    }
    
    func didTapBakery(_ bakery: Bakery) {
        let filter = BakeryDetailFilter(
            bakeryId: bakery.id,
            areaCodes: [bakery.areaID],
            tourCatCodes: CategoryManager.shared.selectedCategoryCodes
        )
        onNavigateToBakeryDetail?(filter)
    }
}
