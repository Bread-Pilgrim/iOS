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
    @Published var isLoading = false
    @Published var visitedSortOption: SortOption = .newest
    @Published var likeSortOption: SortOption = .newest
    
    private let getMyBakeryListUseCase: GetMyBakeryListUseCase
    private var bakeryFetcher: PageFetcher<Bakery>?
    private var currentTab: MyBakeryType = .visited
    
    var onNavigateToBakeryDetail: ((BakeryDetailFilter) -> Void)?

    init(
        getMyBakeryListUseCase: GetMyBakeryListUseCase
    ) {
        self.getMyBakeryListUseCase = getMyBakeryListUseCase
    }
    
    func loadBakeries(tab: MyBakeryType) async {
        guard !isLoading else { return }
        
        currentTab = tab
        isLoading = true
        
        let sortOption = tab == .visited ? visitedSortOption : likeSortOption
        
        bakeryFetcher = PageFetcher<Bakery> { [weak self] cursor, size in
            guard let self = self else { throw APIError.emptyData }
            let request = BakeryMyListRequestDTO(
                cursorValue: cursor,
                pageSize: size,
                sortClause: sortOption
            )
            return try await self.getMyBakeryListUseCase.execute(tab, request: request)
        }
        
        do {
            try await bakeryFetcher?.loadInitial()
            bakeries = bakeryFetcher?.page.items ?? []
        } catch {
            print("Error loading bakeries: \(error)")
        }
        isLoading = false
    }
    
    func loadMore() async {
        guard let fetcher = bakeryFetcher else { return }
        
        do {
            try await fetcher.loadMoreIfScrolledToEnd()
            bakeries = fetcher.page.items
        } catch {
            print("Error loading more bakeries: \(error)")
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
