//
//  BakeRoadRadioButton.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

enum RadioSize {
    case normal
    case small
    
    func lineWidth(_ isSelected: Bool) -> CGFloat {
        switch self {
        case .normal:
            return isSelected ? 6 : 1.5
        case .small:
            return isSelected ? 4.5 : 1.5
        }
    }
}

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let isDisabled: Bool
    let size: RadioSize
    let action: () -> Void

    var body: some View {
        let color = isSelected ? Color.primary500 : Color.gray200
        
        Button(action: {
            if !isDisabled { action() }
        }) {
            HStack {
                Circle()
                    .strokeBorder(isDisabled ? color.opacity(0.43) : color, lineWidth: size.lineWidth(isSelected))
                    .frame(width: size == .normal ? 20 : 16, height: size == .normal ? 20 : 16)
                Text(title)
                    .foregroundColor(isDisabled ? Color.gray200 : Color.gray990)
                    .font(size == .normal ? .bodySmallMedium : .bodyXsmallMedium)
            }
        }
        .disabled(isDisabled)
    }
}
