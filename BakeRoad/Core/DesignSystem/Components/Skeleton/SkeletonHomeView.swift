//
//  SkeletonHomeView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/20/25.
//

import SwiftUI

struct SkeletonHomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SkeletonAreaSelectionView()
                
                SkeletonBakerySection()
                    .padding(.top, 30)
                
                SkeletonBakerySection()
                    .padding(.top, 40)
                
                SkeletonTourSection()
                    .padding(.top, 40)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SkeletonAreaSelectionView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(0..<10, id: \.self) { _ in
                    SkeletonBox(width: 73, height: 32, cornerRadius: 16)
                }
            }
        }
        
    }
}

struct SkeletonBakerySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                SkeletonBox(width: 160, height: 28, cornerRadius: 16)
                Spacer()
                SkeletonBox(width: 43, height: 12.5, cornerRadius: 16)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonBakeryCard()
                    }
                }
            }
            .padding(.top, 12)
        }
    }
}

struct SkeletonBakeryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            SkeletonBox(width: 116, height: 116, cornerRadius: 12)
            
            SkeletonBox(width: 97, height: 20, cornerRadius: 12)
            
            SkeletonBox(width: 76, height: 18, cornerRadius: 12)
            
            SkeletonBox(width: 61, height: 23, cornerRadius: 6)
        }
    }
}

struct SkeletonTourSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                SkeletonBox(width: 190, height: 28, cornerRadius: 16)
                Spacer()
                SkeletonBox(width: 43, height: 12.5, cornerRadius: 16)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    ForEach(0..<5, id: \.self) { index in
                        let width: CGFloat = {
                            if index == 2 {
                                return 57
                            } else if index == 4 {
                                return 69
                            }
                            return 45
                        }()
                        SkeletonBox(width: width, height: 30, cornerRadius: 8)
                    }
                }
            }
            .padding(.top, 16)
            
            VStack(spacing: 20) {
                ForEach(0..<5, id: \.self) { _ in
                    SkeletonTourCard()
                }
            }
            .padding(.top, 12)
        }
    }
}

struct SkeletonTourCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonBox(height: 192, cornerRadius: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    SkeletonBox(width: 37, height: 23, cornerRadius: 6)
                    SkeletonBox(width: 87, height: 23, cornerRadius: 16)
                }
                
                SkeletonBox(width: 104, height: 18, cornerRadius: 16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SkeletonHomeView()
}
