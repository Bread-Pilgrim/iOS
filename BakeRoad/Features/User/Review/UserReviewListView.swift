//
//  UserReviewListView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import SwiftUI

struct UserReviewListView: View {
    @StateObject var viewModel: UserReviewListViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                HStack {
                    Button {
                        viewModel.navigateBack()
                    } label: {
                        Image("arrowLeft")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(16)
                
                Text("내가 쓴 리뷰")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.userReviews) { review in
                        UserReviewCard(review: review) { filter in
                            viewModel.navigateToDetail(filter)
                        } onLikeTapped: { reviewId in
                            viewModel.didTapReviewLikeButton(reviewId)
                        }
                        .onAppear {
                            guard viewModel.userReviews.last == review,
                                  !viewModel.isLoading,
                                  viewModel.nextCursor != nil else { return }
                            Task { await viewModel.loadMoreUserReviews() }
                        }
                    }
                }
                
                if viewModel.isLoading && !viewModel.userReviews.isEmpty {
                    ProgressView()
                        .frame(height: 50)
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
    }
}
