//
//  UserReviewListViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import Foundation

@MainActor
final class UserReviewListViewModel: ObservableObject {
    @Published var userReviews: [UserReview] = []
    @Published var nextCursor: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userReviewUseCase: UserReviewUseCase
    private let reviewLikeUseCase: ReviewLikeUseCase
    private let reviewDislikeUseCase: ReviewDislikeUseCase
    
    var onNavigateBack: (() -> Void)?
    var onNavigateToDetail: ((BakeryDetailFilter) -> Void)?
    
    init(
        userReviewUseCase: UserReviewUseCase,
        reviewLikeUseCase: ReviewLikeUseCase,
        reviewDislikeUseCase: ReviewDislikeUseCase
    ) {
        self.userReviewUseCase = userReviewUseCase
        self.reviewLikeUseCase = reviewLikeUseCase
        self.reviewDislikeUseCase = reviewDislikeUseCase
        
        Task { await loadUserReviews() }
    }
    
    private func loadUserReviews() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = UserReviewRequestDTO(cursorValue: "0", pageSize: 15)
            let userPage = try await userReviewUseCase.execute(request)
            userReviews = userPage.items
            nextCursor = userPage.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "사용자 정보를 불러올 수 없습니다."
        }
    }
    
    func loadMoreUserReviews() async {
        guard !isLoading,
              let nextCursor = nextCursor else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = UserReviewRequestDTO(cursorValue: nextCursor, pageSize: 15)
            let userPage = try await userReviewUseCase.execute(request)
            userReviews.append(contentsOf: userPage.items)
            self.nextCursor = userPage.nextCursor
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "사용자 정보를 불러올 수 없습니다."
        }
    }
    
    func didTapReviewLikeButton(_ reviewId: Int) {
        guard let reviewIndex = userReviews.firstIndex(where: { $0.id == reviewId }) else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let originReivew = userReviews[reviewIndex]
        userReviews[reviewIndex] = originReivew.toggleLike()
        
        Task {
            do {
                if originReivew.isLike {
                    try await reviewDislikeUseCase.execute(reviewId)
                } else {
                    try await reviewLikeUseCase.execute(reviewId)
                }
            } catch let APIError.serverError(_, message) {
                userReviews[reviewIndex] = originReivew
                errorMessage = message
            } catch {
                userReviews[reviewIndex] = originReivew
                errorMessage = "잠시 후 다시 시도해주세요."
            }
        }
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
    
    func navigateToDetail(_ filter: BakeryDetailFilter) {
        onNavigateToDetail?(filter)
    }
}
