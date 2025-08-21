//
//  SkeletonBox.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

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
