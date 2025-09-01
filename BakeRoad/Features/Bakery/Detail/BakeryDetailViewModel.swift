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
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showMenuSelection = false
    
    private var currentReviewType: ReviewType = .visitor
    private var currentSortOption: SortOption = .like
    private var reviewFetcher: PageFetcher<BakeryReview>?
    private var isLoadingMore = false
    
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
        async let tourList = getTourList(areaCodes: areaCodes, tourCatCodes: tourCatCodes)
        async let reviewResult = getBakeryReviews(id, requestDTO: BakeryReviewRequestDTO(cursorValue: "0||0", pageSize: 3, sortClause: .like))
        
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
    
    func didTapReviewWriteButton() {
        guard !isLoading else { return }
        
        isLoading = true
        
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
            
            isLoading = false
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
        guard !isLoading else { return }
        
        isLoading = true
        currentReviewType = type
        currentSortOption = sortOption
        
        // PageFetcher 초기화
        reviewFetcher = PageFetcher<BakeryReview>(pageSize: pageSize) { [weak self] cursor, size in
            guard let self = self else { throw APIError.emptyData }
            
            switch type {
            case .visitor:
                let request = BakeryReviewRequestDTO(cursorValue: cursor, pageSize: size, sortClause: sortOption)
                let result = try await self.getBakeryReviewsUseCase.execute(self.filter.bakeryId, requestDTO: request)
                return result.page
            case .my:
                let request = BakeryMyReviewRequestDTO(cursorValue: cursor, pageSize: size)
                return try await self.getBakeryMyReviewsUseCase.execute(self.filter.bakeryId, requestDTO: request)
            }
        }
        
        do {
            try await reviewFetcher?.loadInitial()
            syncReviewState()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
        
        isLoading = false
    }
    
    // 스크롤 기반 페이징
    func loadMoreReviewsOnScroll() async {
        guard let fetcher = reviewFetcher, 
              !isLoading, 
              !isLoadingMore, 
              hasNextReviews else { return }
        
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            try await fetcher.loadMoreIfScrolledToEnd()
            syncReviewState()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
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
