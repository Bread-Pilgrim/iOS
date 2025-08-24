//
//  RecentSearchView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct RecentSearchView: View {
    let recentSearches: [RecentSearch]
    let onSelectSearch: (String) -> Void
    let onRemoveSearch: (UUID) -> Void
    let onClearAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("최근 검색어")
                    .font(.bodyLargeSemibold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("전체 삭제") {
                    onClearAll()
                }
                .font(.bodyXsmallSemibold)
                .foregroundColor(recentSearches.isEmpty ? .gray200 : .gray800)
                .disabled(recentSearches.isEmpty)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            if recentSearches.isEmpty {
                VStack(alignment: .center, spacing: 4) {
                    Text("아직 검색하신 내역이 없어요.")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                    Text("원하는 매장을 검색해보세요!")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray40)
                .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(recentSearches) { search in
                            RecentSearchItem(
                                searchText: search.text,
                                onSelect: { onSelectSearch(search.text) },
                                onRemove: { onRemoveSearch(search.id) }
                            )
                        }
                    }
                }
                .frame(height: 32)
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

struct RecentSearchItem: View {
    let searchText: String
    let onSelect: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Button {
                onSelect()
            } label: {
                Text(searchText)
                    .font(.body2xsmallMedium)
                    .foregroundColor(.gray990)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .tint(Color.gray990)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray200, lineWidth: 1)
        }
    }
}
