//
//  BadgeEarnedSheet.swift
//  BakeRoad
//
//  Created by 이현호 on 9/4/25.
//

import SwiftUI

import Kingfisher

struct BadgeEarnedSheet: View {
    let badges: [Badge]
    @Binding var isPresented: Bool
    let onGoToBadgeList: () -> Void
    var onDismiss: (() -> Void)?
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            let title = badges.count > 1 ? "축하해요 🎉\n\(badges.count)개의 뱃지를 획득했어요!" : "축하해요 🎉\n뱃지를 획득했어요!"
            Text(title)
                .font(.headingSmallBold)
                .foregroundColor(.primary500)
                .multilineTextAlignment(.center)
                .padding(.vertical, 24)
            
            if badges.count > 1 {
                VStack(spacing: 0) {
                    TabView(selection: $currentIndex) {
                        ForEach(badges.indices, id: \.self) { index in
                            BadgeEarnedCard(badge: badges[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    HStack(spacing: 6) {
                        ForEach(badges.indices, id: \.self) { index in
                            Circle()
                                .fill(currentIndex == index ? Color.primary500 : Color.gray100)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 24)
                }
            } else if let badge = badges.first {
                BadgeEarnedCard(badge: badge)
            }
            
            HStack(spacing: 8) {
                BakeRoadOutlinedButton(title: "닫기", style: .secondary, size: .large) {
                    isPresented = false
                    onDismiss?()
                }
                .frame(maxWidth: .infinity)
                
                BakeRoadSolidButton(title: "내 뱃지 보기", style: .primary, size: .large) {
                    isPresented = false
                    onGoToBadgeList()
                    onDismiss?()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 16)
    }
}

struct BadgeEarnedCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: badge.imgUrl))
                .placeholder {
                    Image("badgePlaceholder")
                        .resizable()
                }
                .resizable()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .background(Color.gray50)
                .frame(width: 90, height: 90)
                .cornerRadius(20)
            
            Text(badge.name)
                .font(.bodyMediumSemibold)
                .foregroundColor(.gray990)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            Text(badge.description)
                .font(.bodyXsmallMedium)
                .foregroundColor(.gray600)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 144)
        }
    }
}
