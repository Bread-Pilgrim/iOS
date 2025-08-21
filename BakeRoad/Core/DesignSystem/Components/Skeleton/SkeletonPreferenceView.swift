//
//  SkeletonPreferenceView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import SwiftUI

struct SkeletonPreferenceView: View {
    let step: OnboardingStep
    
    var body: some View {
        switch step {
        case .breadType:
            SkeletonBreadTypeSection()
        case .flavor:
            SkeletonFlavorSection()
        case .atmosphere:
            SkeletonAtmosphereSection()
        }
    }
}

struct SkeletonBreadTypeSection: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<8, id: \.self) { index in
                let width: [CGFloat] = [222, 295, 209, 229, 304, 205, 157, 155]
                SkeletonBox(width: width[index], height: 30)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SkeletonFlavorSection: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                SkeletonBox(width: 100, height: 30)
                SkeletonBox(width: 167, height: 30)
            }
            
            SkeletonBox(width: 188, height: 30)
            
            HStack(spacing: 12) {
                SkeletonBox(width: 165, height: 30)
                SkeletonBox(width: 72, height: 30)
            }
            
            SkeletonBox(width: 148, height: 30)
        }
        .padding(.horizontal, 16)
    }
}

struct SkeletonAtmosphereSection: View {
    var body: some View {
        VStack(spacing: 12) {
            SkeletonBox(width: 260, height: 30)
            
            HStack(spacing: 12) {
                SkeletonBox(width: 136, height: 30)
                SkeletonBox(width: 115, height: 30)
            }
            
            HStack(spacing: 12) {
                SkeletonBox(width: 179, height: 30)
                SkeletonBox(width: 147, height: 30)
            }
        }
    }
}
