//
//  RecentBakeryView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct RecentBakeryView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.isLoading && viewModel.recentBakeries.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(0..<10, id: \.self) { _ in
                            SkeletonListCard()
                        }
                    }
                }
            } else {
                HStack {
                    Text("최근 조회한 빵집")
                        .font(.bodyLargeSemibold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("전체 삭제") {
                        viewModel.clearAllRecentBakeries()
                    }
                    .font(.bodyXsmallSemibold)
                    .foregroundColor(viewModel.recentBakeries.isEmpty ? .gray200 : .gray800)
                    .disabled(viewModel.recentBakeries.isEmpty)
                }
                .padding(.bottom, 16)
                
                if viewModel.recentBakeries.isEmpty {
                    VStack(alignment: .center, spacing: 4) {
                        Text("최근에 조회한 빵집이 없어요.")
                            .font(.bodyXsmallRegular)
                            .foregroundColor(.gray600)
                        Text("원하는 매장을 검색해보세요!")
                            .font(.bodyXsmallRegular)
                            .foregroundColor(.gray600)
                    }
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray40)
                    .cornerRadius(12)
                    
                    Spacer()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.recentBakeries) { bakery in
                                RecommendBakeryCard(recommendBakery: bakery)
                                    .onTapGesture {
                                        viewModel.didTapBakery(bakeryId: bakery.id, areaCode: bakery.commercialAreaId)
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }
}
