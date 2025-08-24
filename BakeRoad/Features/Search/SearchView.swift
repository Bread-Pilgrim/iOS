//
//  SearchView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(
                text: $viewModel.currentSearchText,
                isSearchFocused: $isSearchFocused,
                onSearchSubmit: {
                    Task {
                        await viewModel.search(viewModel.currentSearchText)
                    }
                },
                onCancel: {
                    viewModel.cancelSearch()
                    isSearchFocused = false
                }
            )
            
            SearchContentView(
                isSearchFocused: isSearchFocused,
                viewModel: viewModel,
                onRecentSearchSelected: { selectedText in
                    Task {
                        await viewModel.selectRecentSearch(selectedText)
                        isSearchFocused = false
                    }
                }
            )
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onChange(of: viewModel.isSearchFocused) { oldValue, newValue in
            if !newValue && viewModel.currentSearchText.isEmpty {
                viewModel.hasPerformedSearch = false
            }
        }
    }
}
