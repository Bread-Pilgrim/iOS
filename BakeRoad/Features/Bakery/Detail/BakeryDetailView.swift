//
//  BakeryDetailView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import SwiftUI

enum DetailTab: String, CaseIterable {
    case home = "홈"
    case menu = "메뉴"
    case review = "리뷰"
    case tour = "근처 관광지"
    
    var showsInfoSection: Bool {
        self == .home
    }
    
    var showsMenuSection: Bool {
        self == .home || self == .menu
    }
    
    var showsReviewSection: Bool {
        self == .home || self == .review
    }
    
    var showsTourSection: Bool {
        self == .home || self == .tour
    }
}

struct BakeryDetailView: View {
    @StateObject var viewModel: BakeryDetailViewModel
    
    @State private var selectedTab: DetailTab = .home
    @State private var showReviewComplete = false
    
    var body: some View {
        Group {
            if let bakeryDetail = viewModel.bakeryDetail,
               let reviewData = viewModel.reviewData {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        DetailInfoSection(
                            bakeryDetail: bakeryDetail,
                            reviewData: reviewData) {
                                viewModel.didTapBackButton()
                            } onLikeButtonTap: {
                                viewModel.didTapBakeryLikeButton()
                            } onWriteButtonTap: {
                                viewModel.didTapReviewWriteButton()
                            }
                        
                        Section(header: detailTabBar) {
                            if selectedTab.showsMenuSection {
                                DetailMenuSection(
                                    menus: bakeryDetail.menus,
                                    selectedTab: $selectedTab
                                )
                            }
                            
                            if selectedTab.showsReviewSection {
                                DetailReviewSection(
                                    reviewData: reviewData,
                                    selectedTab: $selectedTab,
                                    viewModel: viewModel
                                )
                            }
                            
                            if selectedTab.showsTourSection {
                                DetailTourSection(
                                    tours: viewModel.recommendTourList,
                                    selectedTab: $selectedTab
                                )
                            }
                        }
                    }
                }
                .clipped()
            } else {
                SkeletonDetailView()
            }
        }
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == .home {
                viewModel.resetToVisitorReviews()
            } else if newValue == .review {
                Task {
                    await viewModel.loadReviews(type: .visitor)
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { _, message in
            if let message = message {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
        .fullScreenCover(isPresented: $viewModel.showMenuSelection) {
            NavigationStack {
                MenuSelectionView(viewModel: {
                    let writeReviewViewModel = WriteReviewViewModel(
                        bakeryId: viewModel.filter.bakeryId,
                        getBakeryMenuUseCase: viewModel.getBakeryMenuUseCase,
                        writeReviewUseCase: viewModel.writeReviewUseCase
                    )
                    writeReviewViewModel.onReviewSubmitted = { badges in
                        viewModel.showMenuSelection = false
                        showReviewComplete = true
                        if let badges = badges {
                            viewModel.badges = badges
                        }
                    }
                    return writeReviewViewModel
                }())
            }
        }
        .fullScreenCover(isPresented: $showReviewComplete) {
            ReviewCompleteView(
                bakeryId: viewModel.filter.bakeryId,
                badges: viewModel.badges,
                onGoHome: {
                    showReviewComplete = false
                    viewModel.onNavigateHome?()
                },
                onGoToReview: {
                    showReviewComplete = false
                    selectedTab = .review
                    viewModel.currentReviewType = .my
                    Task { await viewModel.loadReviews(type: .my) }
                }) {
                    showReviewComplete = false
                    viewModel.onNavigateToBadgeList?()
                }
        }
    }
    
    private var detailTabBar: some View {
        HStack(spacing: 10) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(tab.rawValue)
                            .font(.bodyMediumSemibold)
                            .foregroundColor(selectedTab == tab ? .gray990 : .gray200)
                            .overlay(
                                Rectangle()
                                    .fill(selectedTab == tab ? Color.gray990 : Color.gray50)
                                    .frame(height: selectedTab == tab ? 1 : 0),
                                alignment: .bottom
                            )
                    }
                }
            }
        }
        .frame(height: 42)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}
