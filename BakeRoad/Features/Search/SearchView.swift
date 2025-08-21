//
//  SearchView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchView: View {
//    @StateObject private var viewModel: SearchViewModel
    @State private var searchText = ""
    @State private var hasSearched = false
    @FocusState private var isSearchFocused: Bool
    
//    init(getBakeryListUseCase: GetBakeryListUseCase) {
//        self._viewModel = StateObject(wrappedValue: SearchViewModel(getBakeryListUseCase: getBakeryListUseCase))
//    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(
                text: $searchText,
                isSearchFocused: $isSearchFocused,
                onSearchSubmit: {
//                    performSearch()
                },
                onCancel: {
                    searchText = ""
                    hasSearched = false
                    isSearchFocused = false
                }
            )
            
            // 콘텐츠
//            SearchContentView(
//                searchText: searchText,
//                isSearchFocused: isSearchFocused,
//                hasSearched: hasSearched,
//                viewModel: viewModel
//            )
        }
        .background(Color.white)
        .navigationBarHidden(true)
//        .task {
//            await viewModel.loadRecentBakeries()
//        }
        .onChange(of: isSearchFocused) { focused in
            if !focused && searchText.isEmpty {
                hasSearched = false
            }
        }
    }
    
//    private func performSearch() {
//        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            return
//        }
//        
//        isSearchFocused = false
//        hasSearched = true
//        
//        Task {
//            await viewModel.search(searchText)
//        }
//    }
}

#Preview {
    SearchView()
}
