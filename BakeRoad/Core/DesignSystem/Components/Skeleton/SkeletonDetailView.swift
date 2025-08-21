//
//  SkeletonDetailView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SkeletonDetailView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SkeletonInfoSection()
                SkeletonSpacer()
                SkeletonMenuSection()
                SkeletonSpacer()
                SkeletonReviewSection()
                SkeletonSpacer()
                SkeletonDetailTourSection()
            }
        }
    }
}

struct SkeletonSpacer: View {
    var body: some View {
        SkeletonBox(height: 8, cornerRadius: 0)
    }
}

struct SkeletonInfoSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBox(height: 250, cornerRadius: 0)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    SkeletonBox(width: 283, height: 28, cornerRadius: 16)
                    SkeletonBox(width: 88, height: 21, cornerRadius: 16)
                }
                
                SkeletonBox(height: 40, cornerRadius: 8)
                
                SkeletonBox(height: 1, cornerRadius: 0)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        let width: CGFloat = {
                            if index == 0 {
                                return 240
                            } else if index == 1 {
                                return 159
                            }
                            return 106
                        }()
                        HStack {
                            SkeletonBox(width: width, height: 20, cornerRadius: 16)
                            Spacer()
                            SkeletonBox(width: 45, height: 18, cornerRadius: 16)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

struct SkeletonMenuSection: View {
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { index in
                let width: CGFloat = {
                    if index == 0 {
                        return 26
                    } else if index == 3 {
                        return 85
                    }
                    return 40
                }()
                SkeletonBox(width: width, height: 22, cornerRadius: 16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        
        SkeletonBox(height: 1, cornerRadius: 0)
            .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                SkeletonBox(width: 154, height: 28, cornerRadius: 16)
                Spacer()
                SkeletonBox(width: 43, height: 12.5, cornerRadius: 16)
            }
            
            ForEach(0..<4, id: \.self) { _ in
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        SkeletonBox(width: 58, height: 23, cornerRadius: 6)
                        SkeletonBox(width: 97, height: 21, cornerRadius: 16)
                        SkeletonBox(width: 76, height: 21, cornerRadius: 6)
                    }
                    
                    Spacer()
                    
                    SkeletonBox(width: 100, height: 80, cornerRadius: 8)
                }
                
                SkeletonBox(height: 1, cornerRadius: 0)
            }
            
            SkeletonBox(height: 40, cornerRadius: 8)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

struct SkeletonReviewSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                SkeletonBox(width: 154, height: 28, cornerRadius: 16)
                Spacer()
                SkeletonBox(width: 43, height: 12.5, cornerRadius: 16)
            }
            
            ForEach(0..<3, id: \.self) { _ in
                SkeletonBox(height: 283, cornerRadius: 12)
            }
            
            SkeletonBox(height: 40, cornerRadius: 8)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

struct SkeletonDetailTourSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SkeletonBox(width: 154, height: 28, cornerRadius: 16)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(0..<10, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 6) {
                            SkeletonBox(width: 100, height: 100, cornerRadius: 8)
                            SkeletonBox(width: 97, height: 21, cornerRadius: 16)
                            SkeletonBox(width: 76, height: 18, cornerRadius: 16)
                        }
                    }
                }
            }
            
            SkeletonBox(height: 40, cornerRadius: 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 28)
    }
}

#Preview {
    SkeletonDetailView()
}
