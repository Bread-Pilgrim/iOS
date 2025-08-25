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
    let isLoadingMore: Bool
    let hasMoreResults: Bool
    let onTapBakery: (Bakery) -> Void
    let onLoadMore: () -> Void
    
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
            } else if searchResults.isEmpty {
                VStack(alignment: .center, spacing: 4) {
                    Text("검색 결과가 없습니다.")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                    Text("다른 키워드로 다시 입력해주세요.")
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
                        ForEach(searchResults) { bakery in
                            BakeryCard(bakery: bakery)
                                .frame(height: 126)
                                .onTapGesture {
                                    onTapBakery(bakery)
                                }
                                .onAppear {
                                    if bakery == searchResults.last && hasMoreResults && !isLoadingMore {
                                        onLoadMore()
                                    }
                                }
                        }
                        
                        if isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
}
