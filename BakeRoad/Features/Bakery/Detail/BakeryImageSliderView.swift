//
//  BakeryImageSliderView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/24/25.
//

import SwiftUI

struct BakeryImageSliderView: View {
    var bakeryDetail: BakeryDetail
    let onBackButtonTap: () -> Void
    let onLikeButtonTap: () -> Void
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(bakeryDetail.imageUrls.indices, id: \.self) { index in
                BakeryImageView(
                    imageUrl: bakeryDetail.imageUrls[index],
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
                    
                    BakeRoadCircleButton(icon: bakeryDetail.isLike ? "favorites_fill" : "heart") {
                        onLikeButtonTap()
                    }
                    .onChange(of: bakeryDetail.isLike) { oldValue, newValue in
                        ToastManager.show(message: newValue ? "내 빵집에 저장했어요." : "내 빵집에서 제거했어요.")
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // 하단
                HStack {
                    BakeryOpenStatusChip(
                        openStatus: bakeryDetail.openStatus,
                        style: .fill
                    )
                    
                    Spacer()
                    
                    BakeRoadChip(
                        title: "\(currentIndex + 1)/\(bakeryDetail.imageUrls.count)",
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
