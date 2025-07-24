//
//  BakeRoadCircleButton.swift
//  BakeRoad
//
//  Created by 이현호 on 7/24/25.
//

import SwiftUI

struct BakeRoadCircleButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 32, height: 32)
                
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .buttonStyle(.plain)
    }
}
