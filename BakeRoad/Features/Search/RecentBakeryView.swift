//
//  RecentBakeryView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct RecentBakeryView: View {
    let recentBakeries: [Bakery]
    let isLoading: Bool
    let onClearAll: () -> Void
    let onTapBakery: (Bakery) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isLoading {
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
                        onClearAll()
                    }
                    .font(.bodyXsmallSemibold)
                    .foregroundColor(recentBakeries.isEmpty ? .gray200 : .gray800)
                    .disabled(recentBakeries.isEmpty)
                }
                .padding(.bottom, 16)
                
                if recentBakeries.isEmpty {
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
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(recentBakeries) { bakery in
                                BakeryCard(bakery: bakery)
                                    .frame(height: 126)
                                    .onTapGesture {
                                        onTapBakery(bakery)
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
