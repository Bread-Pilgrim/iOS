//
//  SkeletonView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/20/25.
//

import SwiftUI

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.4),
                        Color.white.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(20))
                .offset(x: phase)
                .animation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false),
                    value: phase
                )
            )
            .onAppear {
                phase = 300
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
}

// MARK: - Basic Skeleton Components
struct SkeletonBox: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(width: CGFloat? = nil, height: CGFloat, cornerRadius: CGFloat = 8) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.gray50)
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
            .shimmer()
    }
}

// MARK: - Home Skeleton Views
struct SkeletonHomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // 내 취향 추천 빵집 섹션
                SkeletonBakerySection(title: "🥨 내 취향 추천 빵집")
                
                // Hot 빵집 섹션  
                SkeletonBakerySection(title: "🔥 Hot한 빵집 모음")
                    .padding(.top, 40)
                
                // 관광지 섹션
                SkeletonTourSection()
                    .padding(.top, 40)
            }
        }
        .padding(.bottom, 28)
    }
}

struct SkeletonBakerySection: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 헤더
            HStack {
                SkeletonBox(width: 160, height: 24, cornerRadius: 4)
                Spacer()
                SkeletonBox(width: 60, height: 20, cornerRadius: 4)
            }
            .padding(.horizontal, 16)
            
            // 가로 스크롤 카드들
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonBakeryCard()
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 16)
        }
    }
}

struct SkeletonBakeryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 이미지
            SkeletonBox(width: 140, height: 100, cornerRadius: 12)
            
            // 제목
            SkeletonBox(width: 120, height: 16, cornerRadius: 4)
            
            // 부제목
            SkeletonBox(width: 100, height: 14, cornerRadius: 4)
            
            // 평점/거리 정보
            HStack {
                SkeletonBox(width: 40, height: 12, cornerRadius: 4)
                Spacer()
                SkeletonBox(width: 50, height: 12, cornerRadius: 4)
            }
        }
        .frame(width: 140)
    }
}

struct SkeletonTourSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 헤더
            SkeletonBox(width: 180, height: 24, cornerRadius: 4)
                .padding(.horizontal, 16)
            
            // 카테고리 선택
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { _ in
                        SkeletonBox(width: 60, height: 32, cornerRadius: 16)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 12)
            
            // 세로 스크롤 카드들
            VStack(spacing: 20) {
                ForEach(0..<3, id: \.self) { _ in
                    SkeletonTourCard()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
}

struct SkeletonTourCard: View {
    var body: some View {
        HStack(spacing: 12) {
            // 이미지
            SkeletonBox(width: 80, height: 80, cornerRadius: 12)
            
            VStack(alignment: .leading, spacing: 8) {
                // 제목
                SkeletonBox(width: 200, height: 18, cornerRadius: 4)
                
                // 주소
                SkeletonBox(width: 160, height: 14, cornerRadius: 4)
                
                // 카테고리
                SkeletonBox(width: 80, height: 20, cornerRadius: 10)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
