//
//  BakeRoadSegmentedControl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/29/25.
//

import SwiftUI

struct BakeRoadSegmentedControl: View {
    let types: [String]
    @Binding var selectedType: ReviewType

    var body: some View {
        HStack(spacing: 0) {
            ForEach(types.indices, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedType = ReviewType(rawValue: index) ?? .visitor
                    }
                }) {
                    Text(types[index])
                        .font(selectedType == ReviewType(rawValue: index) ? .bodyXsmallSemibold : .bodyXsmallMedium)
                        .foregroundColor(selectedType == ReviewType(rawValue: index) ? .secondary500 : .gray200)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                if selectedType == ReviewType(rawValue: index) {
                                    RoundedRectangle(cornerRadius: 999)
                                        .fill(Color.secondary100)
                                }
                            }
                        )
                }
                .contentShape(Rectangle())
            }
        }
        .padding(4)
        .background(Color.gray40)
        .clipShape(RoundedRectangle(cornerRadius: 999))
    }
}
