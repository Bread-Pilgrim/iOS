//
//  RoundedCorners.swift
//  BakeRoad
//
//  Created by 이현호 on 8/11/25.
//

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath)
    }
}
