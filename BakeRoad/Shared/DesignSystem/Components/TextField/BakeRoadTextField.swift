//
//  BakeRoadTextField.swift
//  BakeRoad
//
//  Created by 이현호 on 6/26/25.
//

import SwiftUI

struct BakeRoadTextField: View {
    let title: String
    let placeholder: String
    let description: String?
    let showTitle: Bool
    let showDescription: Bool
    let isEssential: Bool

    @Binding var text: String
    @FocusState private var isFocused: Bool

    var borderColor: Color {
        isFocused ? .primary500 : .gray400
    }

    var body: some View {
        VStack(alignment: .leading) {
            if showTitle {
                HStack(spacing: 2) {
                    Text(title)
                        .foregroundColor(Color.gray990)
                        .font(.bodyXsmallRegular)

                    if isEssential {
                        Circle()
                            .fill(Color.primary500)
                            .frame(width: 16, height: 16)
                    }
                }
                .padding(.bottom, 4)
            }

            TextField(placeholder, text: $text)
                .focused($isFocused)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor))

            if showDescription, let description = description {
                Text(description)
                    .font(.bodyMediumRegular)
                    .foregroundColor(.gray400)
                    .padding(.top, 8)
            }
        }
    }
}
