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
    @State private var showMenuSelection = false
    
    var body: some View {
        Group {
            if let bakeryDetail = viewModel.bakeryDetail,
               let reviewData = viewModel.reviewData {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        DetailInfoSection(
                            bakeryDetail: bakeryDetail,
                            reviewData: reviewData,
                            isLoadingLike: viewModel.isLoadingLike) {
                                viewModel.didTapBackButton()
                            } onLikeButtonTap: {
                                viewModel.didTapLikeButton()
                            } onWriteButtonTap: {
                                viewModel.didTapWriteButton()
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
        .onAppear {
              viewModel.onNavigateReviewWrite = {
                  showMenuSelection = true
              }
          }
          .onChange(of: viewModel.toastMessage) { _, message in
              if let message = message {
                  ToastManager.show(message: message, type: .error)
                  viewModel.toastMessage = nil
              }
          }
          .fullScreenCover(isPresented: $showMenuSelection) {
              NavigationStack {
                  MenuSelectionView(menus: viewModel.bakeryDetail?.menus ?? [])
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
