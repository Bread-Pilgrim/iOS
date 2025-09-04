//
//  SearchBar.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image("search")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .tint(.black)
                
                
                TextField("빵집이나 메뉴를 검색해보세요.", text: $viewModel.currentSearchText)
                    .focused($isFocused)
                    .font(.bodyXsmallMedium)
                    .foregroundColor(.gray950)
                    .onSubmit {
                        Task { await viewModel.search(viewModel.currentSearchText) }
                    }
                    .padding(.vertical, 12)
                
                Spacer()
                
                if !viewModel.currentSearchText.isEmpty {
                    Button {
                        viewModel.currentSearchText = ""
                        viewModel.hasPerformedSearch = false
                        viewModel.isSearchFocused = true
                    } label: {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .tint(.black)
                    }
                    .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(Color.primary50)
            .cornerRadius(10)
            .onTapGesture {
                isFocused = true
            }
            
            if isFocused || !viewModel.currentSearchText.isEmpty {
                Button("취소") {
                    viewModel.cancelSearch()
                }
                .font(.bodyXsmallSemibold)
                .foregroundColor(.gray800)
                .padding(.horizontal, 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .onChange(of: isFocused) { _, newValue in
            viewModel.isSearchFocused = newValue
        }
        .onChange(of: viewModel.isSearchFocused) { _, newValue in
            isFocused = newValue
        }
    }
}
