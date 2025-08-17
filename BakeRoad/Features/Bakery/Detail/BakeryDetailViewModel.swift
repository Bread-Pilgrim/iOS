//
//  BakeryDetailViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

enum ReviewType {
    case visitor
    case my
}

@MainActor
final class BakeryDetailViewModel: ObservableObject {
    @Published var bakeryDetail: BakeryDetail?
    @Published var recommendTourList: [TourInfo] = []
    @Published var reviews: [BakeryReview] = []
    @Published var reviewData: BakeryReviewData?
    @Published var hasNextReviews = false
    @Published var isLoadingReviews = false
    @Published var isLoadingLike = false
    @Published var errorMessage: String?
    
    private var currentReviewType: ReviewType = .visitor
    private var currentSortOption: SortOption = .like
    private var reviewFetcher: PageFetcher<BakeryReview>?
    
    private let filter: BakeryDetailFilter
    private let getBakeryDetailUseCase: GetBakeryDetailUseCase
    private let getTourListUseCase: GetTourListUseCase
    private let getBakeryReviewsUseCase: GetBakeryReviewsUseCase
    private let getBakeryMyReviewsUseCase: GetBakeryMyReviewsUseCase
    private let bakeryLikeUseCase: BakeryLikeUseCase
    private let bakeryDislikeUseCase: BakeryDislikeUseCase
    
    var onNavigateBack: (() -> Void)?
    
    init(
        filter: BakeryDetailFilter,
        getBakeryDetailUseCase: GetBakeryDetailUseCase,
        getTourListUseCase: GetTourListUseCase,
        getBakeryReviewsUseCase: GetBakeryReviewsUseCase,
        getBakeryMyReviewsUseCase: GetBakeryMyReviewsUseCase,
        bakeryLikeUseCase: BakeryLikeUseCase,
        bakeryDislikeUseCase: BakeryDislikeUseCase
    ) {
        self.filter = filter
        self.getBakeryDetailUseCase = getBakeryDetailUseCase
        self.getTourListUseCase = getTourListUseCase
        self.getBakeryReviewsUseCase = getBakeryReviewsUseCase
        self.getBakeryMyReviewsUseCase = getBakeryMyReviewsUseCase
        self.bakeryLikeUseCase = bakeryLikeUseCase
        self.bakeryDislikeUseCase = bakeryDislikeUseCase
        
        let areaCodes = filter.areaCodes.map(String.init).joined(separator: ",")
        let tourCatCodes = filter.tourCatCodes.joined(separator: ",")
        
        Task { await loadInitial(filter.bakeryId, areaCodes: areaCodes, tourCatCodes: tourCatCodes) }
    }
    
    private func loadInitial(_ id: Int, areaCodes: String, tourCatCodes: String) async {
        async let detail = getBakeryDetail(id)
        async let tourList = getTourList(areaCodes: areaCodes, tourCatCodes: tourCatCodes)
        async let reviewResult = getBakeryReviews(id, requestDTO: BakeryReviewRequestDTO(pageNo: 1, pageSize: 3, sortClause: .like))
        
        bakeryDetail = await detail
        recommendTourList = await tourList
        
        let reviewData = await reviewResult
        reviews = reviewData?.page.items ?? []
        self.reviewData = reviewData?.data
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
    
    func didTapLikeButton() {
        guard !isLoadingLike else { return }
        
        isLoadingLike = true
        
        Task {
            do {
                if bakeryDetail?.isLike ?? true {
                    try await bakeryDislikeUseCase.execute(filter.bakeryId)
                    self.bakeryDetail = bakeryDetail?.toggleLike()
                } else {
                    try await bakeryLikeUseCase.execute(filter.bakeryId)
                    self.bakeryDetail = bakeryDetail?.toggleLike()
                }
            } catch let APIError.serverError(_, message) {
                errorMessage = message
            } catch {
                errorMessage = "잠시 후 다시 시도해주세요."
            }
            
            isLoadingLike = false
        }
    }
}

// 리뷰
extension BakeryDetailViewModel {
    // 홈 탭으로 돌아올 때 리셋
    func resetToVisitorReviews() {
        Task {
            await loadReviews(type: .visitor, sortOption: .like, pageSize: 3)
        }
    }
    
    // 리뷰 로드
    func loadReviews(type: ReviewType, sortOption: SortOption = .like, pageSize: Int = 5) async {
        guard !isLoadingReviews else { return }
        
        isLoadingReviews = true
        currentReviewType = type
        currentSortOption = sortOption
        
        // PageFetcher 초기화
        reviewFetcher = PageFetcher<BakeryReview>(pageSize: pageSize) { [weak self] page, size in
            guard let self = self else { throw APIError.emptyData }
            
            switch type {
            case .visitor:
                let request = BakeryReviewRequestDTO(pageNo: page, pageSize: size, sortClause: sortOption)
                let result = try await self.getBakeryReviewsUseCase.execute(self.filter.bakeryId, requestDTO: request)
                return result.page
            case .my:
                let request = BakeryMyReviewRequestDTO(pageNo: page, pageSize: size)
                return try await self.getBakeryMyReviewsUseCase.execute(self.filter.bakeryId, requestDTO: request)
            }
        }
        
        do {
            try await reviewFetcher?.loadInitial()
            syncReviewState()
        } catch {
            errorMessage = "리뷰를 불러오는데 실패했습니다."
        }
        
        isLoadingReviews = false
    }
    
    // 리뷰 페이징
    func loadMoreReviews(currentReview: BakeryReview) async {
        do {
            try await reviewFetcher?.loadMoreIfNeeded(currentItem: currentReview)
            syncReviewState()
        } catch {
            errorMessage = "리뷰를 더 불러오는데 실패했습니다."
        }
    }
    
    // 정렬 옵션 변경
    func changeSortOption(_ sortOption: SortOption) async {
        await loadReviews(type: .visitor, sortOption: sortOption)
    }
    
    // 리뷰 상태 동기화
    private func syncReviewState() {
        reviews = reviewFetcher?.page.items ?? []
        hasNextReviews = reviewFetcher?.page.hasNext ?? false
    }
}
