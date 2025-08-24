//
//  MyBakeryView.swift
//  BakeRoad
//
//  Created by Claude on 8/24/25.
//

import SwiftUI

struct MyBakeryView: View {
    @State private var selectedTab: MyBakeryTab = .visited
    @State private var visitedSortOption: SortOption = .newest
    @State private var favoriteSortOption: SortOption = .newest
    @State private var showVisitedSortSheet = false
    @State private var showFavoriteSortSheet = false
    
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
                .padding(.bottom, 20)
        }
        .background(Color.white)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .visited:
            VisitedBakeryView(
                selectedSortOption: $visitedSortOption,
                isShowingSortSheet: $showVisitedSortSheet
            )
        case .favorites:
            FavoriteBakeryView(
                selectedSortOption: $favoriteSortOption,
                isShowingSortSheet: $showFavoriteSortSheet
            )
        }
    }
}

enum MyBakeryTab: String, CaseIterable {
    case visited = "다녀온 빵집"
    case favorites = "찜한 빵집"
}

struct MyBakerySegmentedControl: View {
    @Binding var selectedTab: MyBakeryTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MyBakeryTab.allCases, id: \.self) { tab in
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
    @Binding var selectedSortOption: SortOption
    @Binding var isShowingSortSheet: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                BakeRoadTextButton(
                    title: selectedSortOption.displayTitle(),
                    type: .assistive,
                    size: .small) {
                        isShowingSortSheet = true
                    }
                    .sheet(isPresented: $isShowingSortSheet) {
                        SortOptionSheet(
                            selectedOption: $selectedSortOption,
                            options: [.newest, .reviewCountHigh, .avgRatingHigh, .avgRatingLow, .name],
                            isMyBakery: false,
                            onConfirm: {
                                isShowingSortSheet = false
                            },
                            onCancel: {
                                isShowingSortSheet = false
                            }
                        )
                        .presentationDetents([.fraction(0.47)])
                    }
            }
            .frame(height: 28)
            
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
            
            Spacer()
        }
    }
}

struct FavoriteBakeryView: View {
    @Binding var selectedSortOption: SortOption
    @Binding var isShowingSortSheet: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                BakeRoadTextButton(
                    title: selectedSortOption.displayTitle(),
                    type: .assistive,
                    size: .small) {
                        isShowingSortSheet = true
                    }
                    .sheet(isPresented: $isShowingSortSheet) {
                        SortOptionSheet(
                            selectedOption: $selectedSortOption,
                            options: [.newest, .reviewCountHigh, .avgRatingHigh, .avgRatingLow, .name],
                            isMyBakery: false,
                            onConfirm: {
                                isShowingSortSheet = false
                            },
                            onCancel: {
                                isShowingSortSheet = false
                            }
                        )
                        .presentationDetents([.fraction(0.47)])
                    }
            }
            .frame(height: 28)
            
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
            
            Spacer()
        }
    }
}

#Preview {
    MyBakeryView()
}
