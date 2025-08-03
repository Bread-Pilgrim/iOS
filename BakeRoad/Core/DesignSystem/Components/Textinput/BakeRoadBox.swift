//
//  BakeRoadBox.swift
//  BakeRoad
//
//  Created by 이현호 on 8/3/25.
//

import SwiftUI

enum BakeRoadBoxState {
    case `default`
    case active
    case success
}

struct BakeRoadBox: View {
    let title: String?
    let placeholder: String
    let isEssential: Bool
    let showsLetterCount: Bool
    let characterLimit: Int
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    init(title: String? = nil,
         placeholder: String,
         isEssential: Bool,
         showsLetterCount: Bool,
         characterLimit: Int,
         text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.isEssential = isEssential
        self.showsLetterCount = showsLetterCount
        self.characterLimit = characterLimit
        self._text = text
    }
    
    // MARK: - Computed
    private var currentState: BakeRoadBoxState {
        if isFocused {
            return .active
        } else if text.isEmpty {
            return .default
        } else {
            return .success
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                ZStack(alignment: .topLeading) {
                    Text(title)
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray990)
                        .padding(3)
                    if isEssential {
                        Circle()
                            .fill(Color.primary500)
                            .frame(width: 4, height: 4)
                    }
                }
            }
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(for: currentState), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: limitedBinding($text))
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray990)
                        .lineSpacing(4)
                        .focused($isFocused)
                        .padding(.top, 12)
                        .padding(.horizontal, 12)
                        .padding(.bottom, showsLetterCount ? 36 : 12)
                        .background(Color.clear)
                        .frame(minHeight: 100)
                    
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray400)
                            .font(.bodyXsmallRegular)
                            .lineSpacing(4)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 18)
                    }
                    
                    if showsLetterCount {
                        VStack {
                            Spacer()
                            HStack(spacing: 0) {
                                Spacer()
                                Text("\(text.count)")
                                    .font(.body2xsmallRegular)
                                    .foregroundColor(currentState == .default ? .gray100 : .gray990)
                                    .padding(.bottom, 12)
                                
                                Text(" / \(characterLimit)")
                                    .font(.body2xsmallRegular)
                                    .foregroundColor(.gray100)
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 12)
                            }
                        }
                        .allowsHitTesting(false)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func borderColor(for state: BakeRoadBoxState) -> Color {
        switch state {
        case .default: return .gray100
        case .active: return .primary500
        case .success: return .gray100
        }
    }
    
    private func limitedBinding(_ binding: Binding<String>) -> Binding<String> {
        Binding<String>(
            get: { binding.wrappedValue },
            set: { newValue in
                if newValue.count <= characterLimit {
                    binding.wrappedValue = newValue
                } else {
                    binding.wrappedValue = String(newValue.prefix(characterLimit))
                }
            }
        )
    }
}


#Preview {
    BakeRoadBox(title: "Title",
                placeholder: "정성스러운 리뷰는 다른 유저들의 빵 여행에 큰 도움이 됩니다.\n맛, 분위기, 추천 포인트를 자유롭게 남겨주세요!\n(최소 10자 이상 작성해주세요)",
                isEssential: true,
                showsLetterCount: true,
                characterLimit: 300,
                text: .constant(""))
    .frame(height: 150)
    .padding(.horizontal, 16)
}
