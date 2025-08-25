//
//  SkeletonProfileView.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

struct SkeletonProfileView: View {
    var body: some View {
        HStack(spacing: 12) {
            SkeletonBox(width: 56, height: 56, cornerRadius: 28)
            
            VStack(alignment: .leading, spacing: 6) {
                SkeletonBox(width: 65, height: 25, cornerRadius: 22.5)
                
                HStack {
                    SkeletonBox(width: 78, height: 28, cornerRadius: 17.5)
                    
                    Spacer()
                    
                    SkeletonBox(width: 49, height: 28, cornerRadius: 17.5)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}
