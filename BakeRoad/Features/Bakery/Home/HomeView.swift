//
//  HomeView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @ObservedObject private var categoryManager = CategoryManager.shared
    @State private var showPreferenceEdit = false
    
    var body: some View {
        HeaderView {
            Image("header")
        } rightItem: {
            Button {
                showPreferenceEdit = true
            } label: {
                Text("내 취향 변경")
                    .font(.bodySmallSemibold)
                    .foregroundColor(.gray800)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        
        if viewModel.isLoading {
            SkeletonHomeView()
                .padding(.bottom, 28)
        } else {
            AreaSelectionView(
                areas: viewModel.allAreas,
                selectedAreaCodes: viewModel.selectedAreaCodes,
                onToggle: viewModel.toggleArea
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HeaderView {
                        Text("🥨 내 취향 추천 빵집")
                            .font(.headingMediumBold)
                            .foregroundColor(.gray990)
                    } rightItem: {
                        BakeRoadTextButton(
                            title: "전체보기",
                            type: .assistive,
                            size: .small
                        ) {
                            viewModel.didTapPreferenceViewAll()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 21)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(viewModel.preferenceBakeries) { recommendBakery in
                                RecommendBakeryCard(recommendBakery: recommendBakery)
                                    .onTapGesture {
                                        viewModel.didTapBakery(recommendBakery)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    HeaderView {
                        Text("🔥 Hot한 빵집 모음")
                            .font(.headingMediumBold)
                            .foregroundColor(.gray990)
                    } rightItem: {
                        BakeRoadTextButton(
                            title: "전체보기",
                            type: .assistive,
                            size: .small
                        ) {
                            viewModel.didTapHotViewAll()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 40)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(viewModel.hotBakeries) { recommendBakery in
                                RecommendBakeryCard(recommendBakery: recommendBakery)
                                    .onTapGesture {
                                        viewModel.didTapBakery(recommendBakery)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    HeaderView(leftItem:  {
                        Text("🏖️ 같이 가볼만한 관광지")
                            .font(.headingMediumBold)
                            .foregroundColor(.gray990)
                    })
                    .padding(.horizontal, 16)
                    .padding(.top, 40)
                    
                    TourCategorySelectionView(
                        selectedIDs: categoryManager.selectedCategoryCodes,
                        onToggle: viewModel.toggleCategory
                    )
                    .padding(.bottom, 12)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(viewModel.tourInfoList) { item in
                                RecommendTourCard(
                                    title: item.title,
                                    address: item.address,
                                    imageUrl: item.imageUrl,
                                    categoryName: item.categoryName
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(0), location: 0),
                        .init(color: .black, location: 0.1),
                        .init(color: .black, location: 0.9),
                        .init(color: .black.opacity(0), location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .padding(.bottom, 28)
            .refreshable {
                Task { await viewModel.loadInitial() }
            }
            .onChange(of: viewModel.errorMessage) { oldValue, newValue in
                if let message = newValue {
                    ToastManager.show(message: message, type: .error)
                    viewModel.errorMessage = nil
                }
            }
            .fullScreenCover(isPresented: $showPreferenceEdit) {
                OnboardingView(
                    viewModel: viewModel.createOnboardingViewModel(isPreferenceEdit: true),
                    isModal: true,
                    onFinish: {
                        showPreferenceEdit = false
                        Task {
                            await viewModel.loadInitial()
                            ToastManager.show(message: "내 빵 취향이 변경되었습니다!", type: .success)
                        }
                    }
                )
            }
            .sheet(isPresented: $viewModel.showBadgePopup) {
                if let badges = viewModel.badges {
                    BadgeEarnedSheet(badges: badges,
                                     isPresented: $viewModel.showBadgePopup) {
                        viewModel.onGoToBadgeList?()
                    } onDismiss: {
                        viewModel.onBadgePopupDismissed()
                    }
                    .presentationDetents([badges.count > 1 ? .fraction(0.51) : .fraction(0.47)])
                    .presentationDragIndicator(.hidden)
                }
            }
            .sheet(isPresented: $viewModel.showEventPopup) {
                if let eventPopup = viewModel.eventPopup {
                    EventPopupSheet(
                        eventPopup: eventPopup,
                        isPresented: $viewModel.showEventPopup
                    )
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(.clear)
                }
            }
        }
    }
}
