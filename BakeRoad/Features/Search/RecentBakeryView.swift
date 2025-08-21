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
    let onTapBakery: (Bakery) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isLoading {
                // 스켈레톤 로딩
                VStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonListCard()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            } else if recentBakeries.isEmpty {
                // 빈 상태
                VStack(spacing: 16) {
                    Image(systemName: "building.2")
                        .font(.system(size: 48))
                        .foregroundColor(.gray300)
                    
                    Text("최근 조회한 빵집이 없습니다")
                        .font(.body2xsmallMedium)
                        .foregroundColor(.gray500)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                // 헤더
                HStack {
                    Text("최근 조회한 빵집")
                        .font(.headingSmallBold)
                        .foregroundColor(.gray990)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // 최근 조회한 빵집 목록
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(recentBakeries.indices, id: \.self) { index in
                            let bakery = recentBakeries[index]
                            BakeryCard(bakery: bakery)
                                .frame(height: 126)
                                .onTapGesture {
                                    onTapBakery(bakery)
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
    }
}
