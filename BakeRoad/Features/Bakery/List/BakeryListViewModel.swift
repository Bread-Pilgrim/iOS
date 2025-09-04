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
    @Published var nextCursor: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let filter: BakeryListFilter
    private let getBakeryListUseCase: GetBakeryListUseCase
    
    var onNavigateToBakeryDetail: ((Bakery) -> Void)?
    var onNavigateBack: (() -> Void)?
    
    init(
        filter: BakeryListFilter,
        getBakeryListUseCase: GetBakeryListUseCase
    ) {
        self.filter = filter
        self.getBakeryListUseCase = getBakeryListUseCase
        
        Task { await loadInitial() }
    }
    
    private func loadInitial() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = BakeryListRequestDTO(
                area_code: filter.areaCodes.map(String.init).joined(separator: ","),
                cursor_value: "0",
                page_size: 15
            )
            let response = try await getBakeryListUseCase.execute(filter.type, request: request)
            bakeries = response.items
            nextCursor = response.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func loadMoreItems() async {
        guard !isLoading,
              let nextCursor = nextCursor else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = BakeryListRequestDTO(
                area_code: filter.areaCodes.map(String.init).joined(separator: ","),
                cursor_value: nextCursor,
                page_size: 15
            )
            let response = try await getBakeryListUseCase.execute(filter.type, request: request)
            bakeries.append(contentsOf: response.items)
            self.nextCursor = response.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func didTapBakery(_ bakery: Bakery) {
        onNavigateToBakeryDetail?(bakery)
    }
    
    func didTapBackButton() {
        onNavigateBack?()
    }
}
