//
//  MyBakeryViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/24/25.
//

import Foundation

@MainActor
final class MyBakeryViewModel: ObservableObject {
    @Published var bakeries: [Bakery] = []
    @Published var nextCursor: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var visitedSortOption: SortOption = .newest
    @Published var likeSortOption: SortOption = .newest
    
    private let getMyBakeryListUseCase: GetMyBakeryListUseCase
    private var currentTab: MyBakeryType = .visited
    
    var onNavigateToBakeryDetail: ((BakeryDetailFilter) -> Void)?

    init(
        getMyBakeryListUseCase: GetMyBakeryListUseCase
    ) {
        self.getMyBakeryListUseCase = getMyBakeryListUseCase
        
        Task { await loadBakeries(tab: .visited) }
    }
    
    func loadBakeries(tab: MyBakeryType) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        currentTab = tab
        
        let sortOption = tab == .visited ? visitedSortOption : likeSortOption
        
        do {
            let request = BakeryMyListRequestDTO(
                cursorValue: "0||0",
                pageSize: 5,
                sortClause: sortOption
            )
            let bakeryPage = try await getMyBakeryListUseCase.execute(tab, request: request)
            bakeries.removeAll()
            nextCursor = nil
            bakeries = bakeryPage.items
            nextCursor = bakeryPage.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "사용자 정보를 불러올 수 없습니다."
        }
    }
    
    func loadMoreBakeries() async {
        guard !isLoading,
              let nextCursor = nextCursor else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let sortOption = currentTab == .visited ? visitedSortOption : likeSortOption
        
        do {
            let request = BakeryMyListRequestDTO(
                cursorValue: nextCursor,
                pageSize: 5,
                sortClause: sortOption
            )
            let bakeryPage = try await getMyBakeryListUseCase.execute(currentTab, request: request)
            bakeries.append(contentsOf: bakeryPage.items)
            self.nextCursor = bakeryPage.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "사용자 정보를 불러올 수 없습니다."
        }
    }
    
    func onTapBakery(_ bakery: Bakery) {
        let filter = BakeryDetailFilter(
            bakeryId: bakery.id,
            areaCodes: [bakery.areaID],
            tourCatCodes: CategoryManager.shared.selectedCategoryCodes
        )
        onNavigateToBakeryDetail?(filter)
    }
}
