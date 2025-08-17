//
//  BakeryImageSliderView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/24/25.
//

import SwiftUI

struct BakeryImageSliderView: View {
    let imageUrls: [String]
    let openStatus: BakeryOpenStatus
    let onBackButtonTap: () -> Void
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(imageUrls.indices, id: \.self) { index in
                BakeryImageView(
                    imageUrl: imageUrls[index],
                    placeholder: .ratio3_2
                )
                .frame(maxWidth: .infinity)
                .clipped()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 250)
        .overlay {
            VStack {
                // 상단
                HStack {
                    BakeRoadCircleButton(icon: "arrowLeft") {
                        onBackButtonTap()
                    }
                    
                    Spacer()
                    
                    BakeRoadCircleButton(icon: "heart") {
                        print("좋아요")
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // 하단
                HStack {
                    BakeryOpenStatusChip(
                        openStatus: openStatus,
                        style: .fill
                    )
                    
                    Spacer()
                    
                    BakeRoadChip(
                        title: "\(currentIndex + 1)/\(imageUrls.count)",
                        color: .gray,
                        size: .small,
                        style: .fill
                    )
                }
                .padding(16)
            }
        }
    }
}
