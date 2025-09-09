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
    @Published var currentReport: BreadReportListItem
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let getBreadReportUseCase: GetBreadReportUseCase
    private let allReports: [BreadReportListItem]
    
    var onNavigateBack: (() -> Void)?
    
    init(
        getBreadReportUseCase: GetBreadReportUseCase,
        currentReport: BreadReportListItem,
        allReports: [BreadReportListItem]
    ) {
        self.getBreadReportUseCase = getBreadReportUseCase
        self.currentReport = currentReport
        self.allReports = allReports
        
        Task { await loadBreadReport() }
    }
    
    private func loadBreadReport() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            breadReport = try await getBreadReportUseCase.execute(currentReport.toRequestDTO())
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
    
    func canNavigateToPrevious() -> Bool {
        allReports.contains(currentReport.previousMonth())
    }
    
    func canNavigateToNext() -> Bool {
        allReports.contains(currentReport.nextMonth())
    }
    
    func navigateToPrevious() {
        currentReport = currentReport.previousMonth()
        Task { await loadBreadReport() }
    }
    
    func navigateToNext() {
        currentReport = currentReport.nextMonth()
        Task { await loadBreadReport() }
    }
}
