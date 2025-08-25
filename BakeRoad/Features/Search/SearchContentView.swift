//
//  SearchContentView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchContentView: View {
    let isSearchFocused: Bool
    @ObservedObject var viewModel: SearchViewModel
    let onRecentSearchSelected: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if isSearchFocused {
                RecentSearchView(
                    recentSearches: viewModel.recentSearches,
                    onSelectSearch: onRecentSearchSelected,
                    onRemoveSearch: { searchID in
                        viewModel.removeRecentSearch(searchID)
                    },
                    onClearAll: {
                        viewModel.clearAllRecentSearches()
                    }
                )
            } else if viewModel.hasPerformedSearch {
                SearchResultView(
                    searchResults: viewModel.searchResults,
                    isLoading: viewModel.isLoadingSearch,
                    searchText: viewModel.currentSearchText,
                    isLoadingMore: viewModel.isLoadingMore,
                    hasMoreResults: viewModel.hasMoreResults,
                    onTapBakery: { bakery in
                        viewModel.didTapBakery(bakery)
                    },
                    onLoadMore: {
                        Task {
                            await viewModel.loadMoreResults()
                        }
                    }
                )
            }
            else {
                RecentBakeryView(recentBakeries: viewModel.recentBakeries, isLoading: viewModel.isLoadingRecentBakeries) {
                    viewModel.clearAllRecentBakeries()
                } onTapBakery: { bakery in
                    viewModel.didTapBakery(bakery)
                }
            }
            
            Spacer()
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
    }
}
