//
//  View+Extensions.swift
//  BakeRoad
//
//  Created by 이현호 on 6/26/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func cardShadow(level: Int = 1) -> some View {
        switch level {
        case 1:
            return self.shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
        case 2:
            return self.shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
        case 3:
            return self.shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 4)
        case 4:
            return self.shadow(color: .black.opacity(0.20), radius: 12, x: 0, y: 6)
        case 5:
            return self.shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)
        default:
            return self.shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
        }
    }
}
