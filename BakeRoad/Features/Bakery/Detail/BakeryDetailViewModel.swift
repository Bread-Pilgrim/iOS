//
//  BakeryDetailViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

@MainActor
final class BakeryDetailViewModel: ObservableObject {
    @Published var bakeryDetail: BakeryDetail?
    @Published var recommendTourList: [TourInfo] = []
    @Published var bakeryReviews: BakeryReviewPage?
    @Published var errorMessage: String?
    
    private let getBakeryDetailUseCase: GetBakeryDetailUseCase
    private let getTourListUseCase: GetTourListUseCase
    private let getBakeryReviewsUseCase: GetBakeryReviewsUseCase
    
    var onNavigateBack: (() -> Void)?
    
    init(
        filter: BakeryDetailFilter,
        getBakeryDetailUseCase: GetBakeryDetailUseCase,
        getTourListUseCase: GetTourListUseCase,
        getBakeryReviewsUseCase: GetBakeryReviewsUseCase
    ) {
        self.getBakeryDetailUseCase = getBakeryDetailUseCase
        self.getTourListUseCase = getTourListUseCase
        self.getBakeryReviewsUseCase = getBakeryReviewsUseCase
        
        let areaCodes = filter.areaCodes.map(String.init).joined(separator: ",")
        let tourCatCodes = filter.tourCatCodes.joined(separator: ",")
        
        Task { await loadInitial(filter.bakeryId, areaCodes: areaCodes, tourCatCodes: tourCatCodes) }
    }
    
    private func loadInitial(_ id: Int, areaCodes: String, tourCatCodes: String) async {
        async let detail = getBakeryDetail(id)
        async let tourList = getTourList(areaCodes: areaCodes, tourCatCodes: tourCatCodes)
        async let reviews = getBakeryReviews(id, requestDTO: BakeryReviewRequestDTO(pageNo: 1, pageSize: 3, sortClause: .likeCountDesc))
        bakeryDetail = await detail
        recommendTourList = await Array(tourList.prefix(5))
        bakeryReviews = await reviews
    }
    
    private func getBakeryDetail(_ id: Int) async -> BakeryDetail? {
        do {
            return try await getBakeryDetailUseCase.execute(id)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
        return nil
    }
    
    private func getTourList(areaCodes: String, tourCatCodes: String) async -> [TourInfo] {
        do {
            return try await getTourListUseCase.execute(areaCodes: areaCodes, tourCatCodes: tourCatCodes)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
        return []
    }
    
    private func getBakeryReviews(_ id: Int, requestDTO: BakeryReviewRequestDTO) async -> BakeryReviewPage? {
        do {
            return try await getBakeryReviewsUseCase.execute(id, requestDTO: requestDTO)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
        return nil
    }
    
    func didTapBackButton() {
        onNavigateBack?()
    }
}
