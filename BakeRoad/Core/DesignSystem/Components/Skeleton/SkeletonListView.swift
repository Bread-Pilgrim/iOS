//
//  SkeletonListView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SkeletonListView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
//            HStack {
//                SkeletonBox(width: 24, height: 24, cornerRadius: 12)
//                Spacer()
//                SkeletonBox(width: 84, height: 25, cornerRadius: 16)
//                Spacer()
//            }
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(0..<10, id: \.self) { _ in
                    SkeletonListCard()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 31)
        .padding(.bottom, 28)
    }
}

struct SkeletonListCard: View {
    var body: some View {
        HStack(spacing: 12) {
            SkeletonBox(width: 148, height: 118, cornerRadius: 12)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonBox(width: 58, height: 23, cornerRadius: 16)
                
                VStack(alignment: .leading, spacing: 4) {
                    SkeletonBox(width: 97, height: 12, cornerRadius: 16)
                    SkeletonBox(width: 76, height: 12, cornerRadius: 16)
                }
                
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBox(width: 58, height: 23, cornerRadius: 6)
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    SkeletonListView()
}
