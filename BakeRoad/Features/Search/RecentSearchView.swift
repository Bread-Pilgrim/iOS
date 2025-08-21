//
//  RecentSearchView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct RecentSearchView: View {
    let recentSearches: [String]
    let onSelectSearch: (String) -> Void
    let onRemoveSearch: (String) -> Void
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
                .foregroundColor(.gray200)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            if recentSearches.isEmpty {
                VStack(alignment: .center, spacing: 0) {
                    Text("아직 검색하신 내역이 없어요.\n원하는 매장을 검색해보세요!")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                }
                .frame(height: 120)
                .cornerRadius(12)
                .padding(.horizontal, 16)
            } else {
                LazyHStack(spacing: 8) {
                    ForEach(recentSearches, id: \.self) { searchText in
                        RecentSearchItem(
                            searchText: searchText,
                            onSelect: { onSelectSearch(searchText) },
                            onRemove: { onRemoveSearch(searchText) }
                        )
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct RecentSearchItem: View {
    let searchText: String
    let onSelect: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        BakeRoadOutlinedButton(
            title: searchText,
            style: .assistive,
            size: .small,
            trailingIcon: Image(systemName: "xmark")
        ) {
            onSelect()
        }
        trailingIconAction: {
            onRemove()
        }
        
//        HStack(spacing: 12) {
//            Button {
//                onSelect()
//            } label: {
//                HStack(spacing: 12) {
//                    Image(systemName: "clock")
//                        .font(.system(size: 16))
//                        .foregroundColor(.gray400)
//                    
//                    Text(searchText)
//                        .font(.body2xsmallMedium)
//                        .foregroundColor(.gray990)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//            
//            Button {
//                onRemove()
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray400)
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 12)
    }
}
