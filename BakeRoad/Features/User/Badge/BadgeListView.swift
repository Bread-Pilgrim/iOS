//
//  BadgeListView.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import SwiftUI

import Kingfisher

struct BadgeListView: View {
    @StateObject var viewModel: BadgeListViewModel
    
    @State private var showSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        viewModel.navigateBack()
                    } label: {
                        Image("arrowLeft")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(16)
                
                Text("받은 뱃지")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            RepresentBadgeView(badge: viewModel.representedBadge)
                .padding(.vertical, 20)
            
            Rectangle()
                .frame(height: 8)
                .foregroundColor(Color.gray50)
            
            HStack {
                Text("받은 뱃지")
                    .font(.bodyLargeSemibold)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .padding(.leading, 16)
            
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.badgeList) { badge in
                        BadgeView(badge: badge) { selectedBadge in
                            viewModel.selectedBadge = selectedBadge
                            showSheet = true
                        }
                    }
                }
            }
            Spacer()
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
        .sheet(isPresented: $showSheet) {
            if let badge = viewModel.selectedBadge {
                BadgeSheet(badge: badge) { badge in
                    showSheet = false
                }
                .presentationDetents([.height(308)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(20)
            }
        }
    }
}

struct RepresentBadgeView: View {
    let badge: Badge?
    
    var body: some View {
        VStack(spacing: 12) {
            KFImage(URL(string: badge?.imgUrl ?? ""))
                .placeholder {
                    Image("badgePlaceholder")
                        .resizable()
                }
                .resizable()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .background(Color.gray50)
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            
            VStack(spacing: 4) {
                Text("나의 대표뱃지")
                    .font(.bodyMediumSemibold)
                    .foregroundColor(.primary500)
                
                Text(badge?.name ?? "없음")
                    .font(.bodyXsmallMedium)
                    .foregroundColor(.gray600)
            }
        }
    }
}

struct BadgeView: View {
    let badge: Badge
    let onTap: ((Badge) -> Void)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if badge.isRepresentative {
                BakeRoadChip(title: "대표", color: .sub, size: .small, style: .fill)
                    .padding(.leading, 6)
                    .zIndex(1)
            }
            
            VStack(spacing: 10) {
                KFImage(URL(string: badge.imgUrl))
                    .placeholder {
                        Image("badgePlaceholder")
                            .resizable()
                    }
                    .resizable()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .opacity(badge.isEarned ? 1 : 0.5)
                    .background(Color.gray50)
                    .frame(width: 84, height: 84)
                    .cornerRadius(20)
                
                Text(badge.name)
                    .font(.bodyXsmallMedium)
                    .foregroundColor(.gray600)
            }
            .padding(.horizontal, 12.5)
            .padding(.vertical, 8)
        }
        .onTapGesture {
            onTap(badge)
        }
    }
}

struct BadgeSheet: View {
    let badge: Badge
    let onTap: ((Badge) -> Void)
    
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
                .opacity(badge.isEarned ? 1 : 0.5)
                .background(Color.gray50)
                .frame(width: 90, height: 90)
                .cornerRadius(20)
                .padding(.top, 24)
                .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                Text(badge.name)
                    .font(.bodyMediumSemibold)
                    .foregroundColor(.gray990)
                
                Text(badge.description)
                    .font(.bodyXsmallMedium)
                    .foregroundColor(.gray600)
            }
            .padding(.horizontal, 99.5)
            .padding(.bottom, 24)
            
            BakeRoadSolidButton(title: badge.isRepresentative ? "대표 뱃지 해지하기" : "대표 뱃지로 설정",
                                style: badge.isRepresentative ? .secondary : .primary,
                                size: .large,
                                isDisabled: !badge.isEarned) {
                onTap(badge)
            }
        }
        .padding(.horizontal, 16)
    }
}
