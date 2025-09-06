//
//  BakeryDetailViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

enum ReviewType: Int {
    case visitor
    case my
}

@MainActor
final class BakeryDetailViewModel: ObservableObject {
    @Published var bakeryDetail: BakeryDetail?
    @Published var recommendTourList: [TourInfo] = []
    @Published var reviews: [BakeryReview] = []
    @Published var reviewData: BakeryReviewData?
    @Published var nextCursor: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showMenuSelection = false
    @Published var currentReviewType: ReviewType = .visitor
    @Published var currentSortOption: SortOption = .like
    @Published var badges: [Badge] = []
    
    let filter: BakeryDetailFilter
    private let getBakeryDetailUseCase: GetBakeryDetailUseCase
    private let getTourListUseCase: GetTourListUseCase
    private let getBakeryReviewsUseCase: GetBakeryReviewsUseCase
    private let getBakeryMyReviewsUseCase: GetBakeryMyReviewsUseCase
    private let bakeryLikeUseCase: BakeryLikeUseCase
    private let bakeryDislikeUseCase: BakeryDislikeUseCase
    private let reviewLikeUseCase: ReviewLikeUseCase
    private let reviewDislikeUseCase: ReviewDislikeUseCase
    private let getBakeryReviewEligibilityUseCase: GetBakeryReviewEligibilityUseCase
    
    let getBakeryMenuUseCase: GetBakeryMenuUseCase
    let writeReviewUseCase: WriteReviewUseCase
    
    var onNavigateBack: (() -> Void)?
    
    init(
        filter: BakeryDetailFilter,
        getBakeryDetailUseCase: GetBakeryDetailUseCase,
        getTourListUseCase: GetTourListUseCase,
        getBakeryReviewsUseCase: GetBakeryReviewsUseCase,
        getBakeryMyReviewsUseCase: GetBakeryMyReviewsUseCase,
        bakeryLikeUseCase: BakeryLikeUseCase,
        bakeryDislikeUseCase: BakeryDislikeUseCase,
        reviewLikeUseCase: ReviewLikeUseCase,
        reviewDislikeUseCase: ReviewDislikeUseCase,
        getBakeryReviewEligibilityUseCase: GetBakeryReviewEligibilityUseCase,
        getBakeryMenuUseCase: GetBakeryMenuUseCase,
        writeReviewUseCase: WriteReviewUseCase
    ) {
        self.filter = filter
        self.getBakeryDetailUseCase = getBakeryDetailUseCase
        self.getTourListUseCase = getTourListUseCase
        self.getBakeryReviewsUseCase = getBakeryReviewsUseCase
        self.getBakeryMyReviewsUseCase = getBakeryMyReviewsUseCase
        self.bakeryLikeUseCase = bakeryLikeUseCase
        self.bakeryDislikeUseCase = bakeryDislikeUseCase
        self.reviewLikeUseCase = reviewLikeUseCase
        self.reviewDislikeUseCase = reviewDislikeUseCase
        self.getBakeryReviewEligibilityUseCase = getBakeryReviewEligibilityUseCase
        self.getBakeryMenuUseCase = getBakeryMenuUseCase
        self.writeReviewUseCase = writeReviewUseCase
        
        let areaCodes = filter.areaCodes.map(String.init).joined(separator: ",")
        let tourCatCodes = filter.tourCatCodes.joined(separator: ",")
        
        Task { await loadInitial(filter.bakeryId, areaCodes: areaCodes, tourCatCodes: tourCatCodes) }
    }
    
    private func loadInitial(_ id: Int, areaCodes: String, tourCatCodes: String) async {
        async let detail = getBakeryDetail(id)
        async let tourList = getTourList(areaCodes: areaCodes,
                                         tourCatCodes: tourCatCodes)
        async let reviewResult = getBakeryReviews(id,
                                                  requestDTO: BakeryReviewRequestDTO(cursorValue: "0||0",
                                                                                     pageSize: 3,
                                                                                     sortClause: .like))
        
        bakeryDetail = await detail
        recommendTourList = await tourList
        let response = await reviewResult
        reviews = response?.page.items ?? []
        reviewData = response?.data
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
    
    private func getBakeryMyReviews(_ id: Int, requestDTO: BakeryMyReviewRequestDTO) async -> Page<BakeryReview>? {
        do {
            return try await getBakeryMyReviewsUseCase.execute(id, requestDTO: requestDTO)
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
    
    func didTapReviewWriteButton() {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        Task {
            do {
                let isEligible = try await getBakeryReviewEligibilityUseCase.execute(filter.bakeryId)
                
                if isEligible.isEligible {
                    showMenuSelection = true
                } else {
                    errorMessage = "오늘 이미 리뷰를 남겼어요!\n리뷰는 하루에 하나만 작성할 수 있습니다 :)"
                }
            } catch let APIError.serverError(_, message) {
                errorMessage = message
            } catch {
                errorMessage = "잠시 후 다시 시도해주세요."
            }
        }
    }
    
    func didTapBakeryLikeButton() {
        guard let originalDetail = bakeryDetail else { return }
        bakeryDetail = originalDetail.toggleLike()
        
        Task {
            do {
                if originalDetail.isLike {
                    try await bakeryDislikeUseCase.execute(filter.bakeryId)
                } else {
                    try await bakeryLikeUseCase.execute(filter.bakeryId)
                }
            } catch let APIError.serverError(_, message) {
                bakeryDetail = originalDetail
                errorMessage = message
            } catch {
                bakeryDetail = originalDetail
                errorMessage = "잠시 후 다시 시도해주세요."
            }
        }
    }
    
    func didTapReviewLikeButton(_ reviewId: Int) {
        guard let reviewIndex = reviews.firstIndex(where: { $0.id == reviewId }) else { return }
        let originReivew = reviews[reviewIndex]
        reviews[reviewIndex] = originReivew.toggleLike()
        
        Task {
            do {
                if originReivew.isLike {
                    try await reviewDislikeUseCase.execute(reviewId)
                } else {
                    try await reviewLikeUseCase.execute(reviewId)
                }
                
            } catch let APIError.serverError(_, message) {
                reviews[reviewIndex] = originReivew
                errorMessage = message
            } catch {
                reviews[reviewIndex] = originReivew
                errorMessage = "잠시 후 다시 시도해주세요."
            }
        }
    }
}

extension BakeryDetailViewModel {
    func resetToVisitorReviews() {
        Task {
            await loadReviews(type: .visitor, sortOption: .like, pageSize: 3)
        }
    }
    
    func changeSortOption(_ sortOption: SortOption) async {
        await loadReviews(type: .visitor, sortOption: sortOption)
    }
    
    func loadReviews(type: ReviewType, sortOption: SortOption = .like, pageSize: Int = 5) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        currentReviewType = type
        currentSortOption = sortOption
        
        do {
            switch type {
            case .visitor:
                let request = BakeryReviewRequestDTO(cursorValue: "0||0", pageSize: pageSize, sortClause: sortOption)
                let response = try await getBakeryReviewsUseCase.execute(filter.bakeryId, requestDTO: request)
                reviews = response.page.items
                reviewData = response.data
                nextCursor = response.page.nextCursor
            case .my:
                let request = BakeryMyReviewRequestDTO(cursorValue: "0", pageSize: pageSize)
                let response = try await getBakeryMyReviewsUseCase.execute(filter.bakeryId, requestDTO: request)
                reviews = response.items
                nextCursor = response.nextCursor
            }
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func loadMoreReviews() async {
        guard !isLoading,
              let nextCursor = nextCursor else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            switch currentReviewType {
            case .visitor:
                let request = BakeryReviewRequestDTO(cursorValue: nextCursor, pageSize: 5, sortClause: currentSortOption)
                let response = try await getBakeryReviewsUseCase.execute(filter.bakeryId, requestDTO: request)
                reviews.append(contentsOf: response.page.items)
                reviewData = response.data
                self.nextCursor = response.page.nextCursor
            case .my:
                let request = BakeryMyReviewRequestDTO(cursorValue: nextCursor, pageSize: 5)
                let response = try await getBakeryMyReviewsUseCase.execute(filter.bakeryId, requestDTO: request)
                reviews = response.items
                self.nextCursor = response.nextCursor
            }
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
}
