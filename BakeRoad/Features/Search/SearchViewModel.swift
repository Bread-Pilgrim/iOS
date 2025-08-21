//
//  SearchViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var recentSearches: [String] = []
    @Published var recentBakeries: [Bakery] = []
    @Published var searchResults: [Bakery] = []
    @Published var isLoadingRecentBakeries = false
    @Published var isLoadingSearch = false
    @Published var errorMessage: String?
    
    private let recentSearchManager = RecentSearchManager()
    private let getBakeryListUseCase: GetBakeryListUseCase
    
    var onNavigateToBakeryDetail: ((Bakery) -> Void)?
    
    init(getBakeryListUseCase: GetBakeryListUseCase) {
        self.getBakeryListUseCase = getBakeryListUseCase
        loadRecentSearches()
    }
    
    func loadRecentSearches() {
        recentSearches = recentSearchManager.getRecentSearches()
    }
    
    func loadRecentBakeries() async {
        isLoadingRecentBakeries = true
        errorMessage = nil
        
        do {
            // TODO: 최근 조회한 빵집 API 호출
            // 임시로 빈 배열 설정
            recentBakeries = []
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "최근 조회한 빵집을 불러올 수 없습니다."
        }
        
        isLoadingRecentBakeries = false
    }
    
    func search(_ searchText: String) async {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // 최근 검색어에 추가
        recentSearchManager.addRecentSearch(trimmedText)
        loadRecentSearches()
        
        isLoadingSearch = true
        errorMessage = nil
        
//        do {
//            let request = BakeryListRequestDTO(
//                area_code: "",
//                page_no: 1,
//                page_size: 20,
//                search: trimmedText
//            )
//            
//            let response = try await getBakeryListUseCase.execute(.all, request: request)
//            searchResults = response.items
//        } catch let APIError.serverError(_, message) {
//            errorMessage = message
//        } catch {
//            errorMessage = "검색 결과를 불러올 수 없습니다."
//        }
//        
        isLoadingSearch = false
    }
    
    func selectRecentSearch(_ searchText: String) async {
        await search(searchText)
    }
    
    func removeRecentSearch(_ searchText: String) {
        recentSearchManager.removeRecentSearch(searchText)
        loadRecentSearches()
    }
    
    func clearAllRecentSearches() {
        recentSearchManager.clearAllRecentSearches()
        loadRecentSearches()
    }
    
    func didTapBakery(_ bakery: Bakery) {
        onNavigateToBakeryDetail?(bakery)
    }
}
