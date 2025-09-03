//
//  SearchResultView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            contentView
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading && viewModel.searchResults.isEmpty {
            loadingView
        } else if viewModel.searchResults.isEmpty {
            emptyView
        } else {
            resultListView
        }
    }
    
    private var loadingView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(0..<10, id: \.self) { _ in
                    SkeletonListCard()
                }
            }
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 0) {
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
        }
    }
    
    private var resultListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.searchResults) { bakery in
                    BakeryCard(bakery: bakery)
                        .frame(height: 126)
                        .onAppear {
                            guard viewModel.searchResults.last == bakery,
                                  !viewModel.isLoading,
                                  viewModel.nextCursor != nil else { return }
                            Task { await viewModel.loadMoreResults() }
                        }
                        .onTapGesture {
                            viewModel.didTapBakery(bakeryId: bakery.id, areaCode: bakery.areaID)
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
        }
    }
}
