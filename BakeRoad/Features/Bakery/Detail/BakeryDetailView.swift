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
    @State private var scrollPosition = ScrollPosition()
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        Group {
            if let bakeryDetail = viewModel.bakeryDetail,
               let reviewData = viewModel.reviewData {
                ZStack(alignment: .top) {
                    HeaderView {
                        Button {
                            viewModel.didTapBackButton()
                        } label: {
                            Image("arrowLeft")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(16)
                    } centerItem: {
                        Text(bakeryDetail.name)
                            .font(.headingSmallBold)
                            .foregroundColor(.gray990)
                            .padding(.vertical, 15.5)
                            .opacity(titleOpacity)
                    } rightItem: {
                        Button {
                            viewModel.didTapBakeryLikeButton()
                        } label: {
                            Image(bakeryDetail.isLike ? "favorites_fill" : "heart")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(16)
                    }
                    .background(Color.white.opacity(headerOpacity))
                    .frame(height: 56)
                    .cardShadow(level: 2)
                    .opacity(headerOpacity)
                    .zIndex(1)
                    
                    ScrollView(.vertical) {
                        scrollObservableView
                        
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
                                .id(0)
                            
                            Section(header: detailTabBar.id(1)) {
                                if selectedTab.showsMenuSection {
                                    DetailMenuSection(
                                        menus: bakeryDetail.menus,
                                        selectedTab: $selectedTab,
                                        scrollPosition: $scrollPosition
                                    )
                                    .id(2)
                                }
                                
                                if selectedTab.showsReviewSection {
                                    DetailReviewSection(
                                        reviewData: reviewData,
                                        selectedTab: $selectedTab,
                                        scrollPosition: $scrollPosition,
                                        viewModel: viewModel
                                    )
                                    .id(3)
                                }
                                
                                if selectedTab.showsTourSection {
                                    DetailTourSection(
                                        tours: viewModel.recommendTourList,
                                        selectedTab: $selectedTab,
                                        scrollPosition: $scrollPosition
                                    )
                                    .id(4)
                                }
                            }
                        }
                    }
                    .clipped()
                    .coordinateSpace(name: "scrollView")
                    .onPreferenceChange(ScrollOffsetKey.self) {
                        scrollOffset = $0
                    }
                }
            } else {
                SkeletonDetailView()
            }
        }
        .scrollPosition($scrollPosition)
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
        .onChange(of: viewModel.successMessage) { _, message in
            if let message = message {
                ToastManager.show(message: message)
                viewModel.successMessage = nil
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
    
    private var headerOpacity: Double {
        let fadeStart: CGFloat = 0
        let fadeEnd: CGFloat = -100
        
        if scrollOffset > fadeStart { return 0 }
        if scrollOffset < fadeEnd { return 1 }
        
        let progress = (fadeStart - scrollOffset) / (fadeStart - fadeEnd)
        return progress
    }
    
    private var titleOpacity: Double {
        let fadeStart: CGFloat = -250
        let fadeEnd: CGFloat = -350
        
        if scrollOffset > fadeStart { return 0 }
        if scrollOffset < fadeEnd { return 1 }
        
        let progress = (fadeStart - scrollOffset) / (fadeStart - fadeEnd)
        return progress
    }
    
    private var detailTabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                        scrollPosition.scrollTo(id: 1, anchor: .top)
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
    
    private var scrollObservableView: some View {
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .named("scrollView")).origin.y
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetY
                )
        }
        .frame(height: 0)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
