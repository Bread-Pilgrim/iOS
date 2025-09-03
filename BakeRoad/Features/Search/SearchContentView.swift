//
//  SearchContentView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchContentView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSearchFocused {
                RecentSearchView(viewModel: viewModel)
            } else if viewModel.hasPerformedSearch {
                SearchResultView(viewModel: viewModel)
            } else {
                RecentBakeryView(viewModel: viewModel)
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
