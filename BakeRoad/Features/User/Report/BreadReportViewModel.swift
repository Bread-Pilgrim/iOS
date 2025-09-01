//
//  BreadReportViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

@MainActor
final class BreadReportViewModel: ObservableObject {
    @Published var breadReport: BreadReport?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let getBreadReportUseCase: GetBreadReportUseCase
    
    var onNavigateBack: (() -> Void)?
    
    init(
        request: BreadReportRequestDTO,
        getBreadReportUseCase: GetBreadReportUseCase
    ) {
        self.getBreadReportUseCase = getBreadReportUseCase
        
        Task { await loadBreadReport(request) }
    }
    
    func loadBreadReport(_ request: BreadReportRequestDTO) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            breadReport = try await getBreadReportUseCase.execute(request)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
}
