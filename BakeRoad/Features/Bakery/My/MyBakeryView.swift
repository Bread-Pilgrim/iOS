//
//  MyBakeryView.swift
//  BakeRoad
//
//  Created by Claude on 8/24/25.
//

import SwiftUI

struct MyBakeryView: View {
    @StateObject var viewModel: MyBakeryViewModel
    @State private var selectedTab: MyBakeryType = .visited
    @State private var showVisitedSortSheet = false
    @State private var showLikeSortSheet = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("내 빵집")
                .font(.headingSmallBold)
                .foregroundColor(.black)
                .padding(.top, 16)
                .padding(.bottom, 25)
            
            MyBakerySegmentedControl(
                selectedTab: $selectedTab
            )
            
            contentView
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 16)
        }
        .background(Color.white)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .visited:
            VisitedBakeryView(
                viewModel: viewModel,
                isShowingSortSheet: $showVisitedSortSheet
            )
            .onAppear {
                Task { await viewModel.loadBakeries(tab: .visited) }
            }
        case .like:
            LikeBakeryView(
                viewModel: viewModel,
                isShowingSortSheet: $showLikeSortSheet
            )
            .onAppear {
                Task { await viewModel.loadBakeries(tab: .like) }
            }
        }
    }
}

enum MyBakeryType: String, CaseIterable {
    case visited = "다녀온 빵집"
    case like = "찜한 빵집"
    
    var listEndPoint: String {
        switch self {
        case .visited:
            return BakeryEndPoint.listVisited
        case .like:
            return BakeryEndPoint.listLike
        }
    }
}

struct MyBakerySegmentedControl: View {
    @Binding var selectedTab: MyBakeryType
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MyBakeryType.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 10) {
                        Text(tab.rawValue)
                            .font(.bodyMediumSemibold)
                            .foregroundColor(selectedTab == tab ? .gray990 : .gray200)
                        
                        Rectangle()
                            .fill(selectedTab == tab ? Color.gray990 : Color.gray50)
                            .frame(height: 1)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct VisitedBakeryView: View {
    @ObservedObject var viewModel: MyBakeryViewModel
    @Binding var isShowingSortSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                BakeRoadTextButton(
                    title: viewModel.visitedSortOption.displayTitle(isMyBakery: true),
                    type: .assistive,
                    size: .small
                ) {
                    isShowingSortSheet = true
                }
                .sheet(isPresented: $isShowingSortSheet) {
                    SortOptionSheet(
                        selectedOption: $viewModel.visitedSortOption,
                        options: [.newest, .reviewCountHigh, .avgRatingHigh, .avgRatingLow, .name],
                        isMyBakery: true,
                        onConfirm: {
                            isShowingSortSheet = false
                            Task { await viewModel.loadBakeries(tab: .visited) }
                        },
                        onCancel: { isShowingSortSheet = false }
                    )
                    .presentationDetents([.fraction(0.47)])
                }
            }
            .frame(height: 28)
            
            if viewModel.bakeries.isEmpty && viewModel.isLoading {
                SkeletonListView()
            } else if viewModel.bakeries.isEmpty {
                VStack(alignment: .center, spacing: 4) {
                    Text("아직 다녀온 빵집이 없어요 🥲")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                    Text("방문 후 리뷰를 남겨주시면 다녀온 빵집에 추가돼요!")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray40)
                .cornerRadius(12)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.bakeries) { bakery in
                            BakeryCard(bakery: bakery)
                                .frame(height: 126)
                                .onAppear {
                                    guard viewModel.bakeries.last == bakery,
                                          !viewModel.isLoading,
                                          viewModel.nextCursor != nil else { return }
                                    Task { await viewModel.loadMoreBakeries() }
                                }
                                .onTapGesture {
                                    viewModel.onTapBakery(bakery)
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct LikeBakeryView: View {
    @ObservedObject var viewModel: MyBakeryViewModel
    @Binding var isShowingSortSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                BakeRoadTextButton(
                    title: viewModel.likeSortOption.displayTitle(isMyBakery: true),
                    type: .assistive,
                    size: .small
                ) {
                    isShowingSortSheet = true
                }
                .sheet(isPresented: $isShowingSortSheet) {
                    SortOptionSheet(
                        selectedOption: $viewModel.likeSortOption,
                        options: [.newest, .reviewCountHigh, .avgRatingHigh, .avgRatingLow, .name],
                        isMyBakery: true,
                        onConfirm: {
                            isShowingSortSheet = false
                            Task { await viewModel.loadBakeries(tab: .like) }
                        },
                        onCancel: { isShowingSortSheet = false }
                    )
                    .presentationDetents([.fraction(0.47)])
                }
            }
            .frame(height: 28)
            
            if viewModel.bakeries.isEmpty && viewModel.isLoading {
                SkeletonListView()
            } else if viewModel.bakeries.isEmpty {
                VStack(alignment: .center, spacing: 4) {
                    Text("아직 찜한 빵집이 없어요 🥲")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                    Text("가고 싶은 빵집을 추가해봐요!")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray40)
                .cornerRadius(12)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.bakeries) { bakery in
                            BakeryCard(bakery: bakery)
                                .frame(height: 126)
                                .onAppear {
                                    guard viewModel.bakeries.last == bakery,
                                          !viewModel.isLoading,
                                          viewModel.nextCursor != nil else { return }
                                    Task { await viewModel.loadMoreBakeries() }
                                }
                                .onTapGesture {
                                    viewModel.onTapBakery(bakery)
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}
