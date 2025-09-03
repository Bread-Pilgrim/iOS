//
//  SearchView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(viewModel: viewModel)
            SearchContentView(viewModel: viewModel)
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
