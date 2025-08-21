//
//  SearchBar.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var isSearchFocused: FocusState<Bool>.Binding
    let onSearchSubmit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image("search")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .tint(.black)
                    
                
                TextField("빵집이나 메뉴를 검색해보세요.", text: $text)
                    .focused(isSearchFocused)
                    .font(.bodyXsmallMedium)
                    .foregroundColor(.gray950)
                    .onSubmit {
                        onSearchSubmit()
                    }
                    .padding(.vertical, 12)
                
                Spacer()
                
                if !text.isEmpty {
                    Button {
                        text = ""
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
            
            if isSearchFocused.wrappedValue {
                Button("취소") {
                    onCancel()
                }
                .font(.bodyXsmallSemibold)
                .foregroundColor(.gray800)
                .padding(.horizontal, 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}
