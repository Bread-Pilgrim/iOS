//
//  SearchResultView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchResultView: View {
    let searchResults: [Bakery]
    let isLoading: Bool
    let searchText: String
    let onTapBakery: (Bakery) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isLoading {
                // 스켈레톤 로딩
                VStack(spacing: 16) {
                    ForEach(0..<8, id: \.self) { _ in
                        SkeletonListCard()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            } else if searchResults.isEmpty {
                // 검색 결과 없음
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.gray300)
                    
                    VStack(spacing: 8) {
                        Text("'\(searchText)' 검색 결과가 없습니다")
                            .font(.bodyMediumMedium)
                            .foregroundColor(.gray900)
                        
                        Text("다른 키워드로 검색해보세요")
                            .font(.body2xsmallMedium)
                            .foregroundColor(.gray500)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                // 검색 결과 헤더
                HStack {
                    Text("'\(searchText)' 검색결과 \(searchResults.count)개")
                        .font(.headingSmallBold)
                        .foregroundColor(.gray990)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // 검색 결과 목록
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(searchResults.indices, id: \.self) { index in
                            let bakery = searchResults[index]
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
