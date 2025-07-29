//
//  BakeRoadSegmentedControl.swift
//  BakeRoad
//
//  Created by 이현호 on 7/29/25.
//

import SwiftUI

struct BakeRoadSegmentedControl: View {
    let types: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(types.indices, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedIndex = index
                    }
                }) {
                    Text(types[index])
                        .font(selectedIndex == index ? .bodyXsmallSemibold : .bodyXsmallMedium)
                        .foregroundColor(selectedIndex == index ? .secondary500 : .gray200)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                if selectedIndex == index {
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
