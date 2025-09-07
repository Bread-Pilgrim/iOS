//
//  ReviewCompleteView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/19/25.
//

import SwiftUI

struct ReviewCompleteView: View {
    let bakeryId: Int
    let badges: [Badge]
    let onGoHome: () -> Void
    let onGoToReview: () -> Void
    let onGoToBadgeList: () -> Void
    
    @State private var showBadgeSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(alignment: .center, spacing: 4) {
                Text("리뷰를 작성했어요!")
                    .font(.headingMediumBold)
                    .foregroundColor(.primary500)
                
                Text("소중한 경험을 남겨주셔서 감사합니다 🍞")
                    .font(.bodyMediumSemibold)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 61)
            
            Spacer()
            
            HStack(spacing: 8) {
                BakeRoadSolidButton(title: "홈으로", style: .secondary, size: .large) {
                    onGoHome()
                }
                
                BakeRoadSolidButton(title: "리뷰 보기", style: .primary, size: .large) {
                    onGoToReview()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            showBadgeSheet = badges.count > 0
        }
        .sheet(isPresented: $showBadgeSheet) {
            BadgeEarnedSheet(
                badges: badges,
                isPresented: $showBadgeSheet,
                onGoToBadgeList: onGoToBadgeList
            )
            .presentationDetents([badges.count > 1 ? .fraction(0.51) : .fraction(0.47)])
            .presentationDragIndicator(.hidden)
        }
    }
}
