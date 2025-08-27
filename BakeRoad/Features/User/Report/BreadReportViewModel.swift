//
//  BreadReportViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

@MainActor
final class BreadReportViewModel: ObservableObject {
    @Published var breadReportList: [BreadReportListItem] = []
    @Published var nextCursor: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let getBreadReportListUseCase: GetBreadReportListUseCase
    
    var onNavigateBack: (() -> Void)?
    var onNavigateToReport: ((BreadReportListItem) -> Void)?
    
    init(
        getBreadReportListUseCase: GetBreadReportListUseCase
    ) {
        self.getBreadReportListUseCase = getBreadReportListUseCase
        
        Task { await loadBreadReportList() }
    }
    
    private func loadBreadReportList() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = BreadReportListRequestDTO(cursorValue: "0", pageSize: 15)
            let response = try await getBreadReportListUseCase.execute(request)
            self.breadReportList = response.items
            self.nextCursor = response.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func loadMoreBreadReportList() async {
        guard !isLoading,
              let nextCursor = nextCursor else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = BreadReportListRequestDTO(cursorValue: nextCursor, pageSize: 15)
            let response = try await getBreadReportListUseCase.execute(request)
            self.breadReportList.append(contentsOf: response.items)
            self.nextCursor = response.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
    
    func navigateToReport(_ item: BreadReportListItem) {
        onNavigateToReport?(item)
    }
}
