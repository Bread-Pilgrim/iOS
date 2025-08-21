//
//  SearchContentView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchContentView: View {
    let searchText: String
    let isSearchFocused: Bool
    let hasSearched: Bool
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if isSearchFocused {
                RecentSearchView(
                    recentSearches: viewModel.recentSearches,
                    onSelectSearch: { searchText in
                        Task {
                            await viewModel.selectRecentSearch(searchText)
                        }
                    },
                    onRemoveSearch: { searchText in
                        viewModel.removeRecentSearch(searchText)
                    },
                    onClearAll: {
                        viewModel.clearAllRecentSearches()
                    }
                )
            } else if hasSearched {
                SearchResultView(
                    searchResults: viewModel.searchResults,
                    isLoading: viewModel.isLoadingSearch,
                    searchText: searchText,
                    onTapBakery: { bakery in
                        viewModel.didTapBakery(bakery)
                    }
                )
            } else {
                RecentBakeryView(
                    recentBakeries: viewModel.recentBakeries,
                    isLoading: viewModel.isLoadingRecentBakeries,
                    onTapBakery: { bakery in
                        viewModel.didTapBakery(bakery)
                    }
                )
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
            }
        }
    }
}
