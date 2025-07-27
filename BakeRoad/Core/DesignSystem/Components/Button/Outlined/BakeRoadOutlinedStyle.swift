//
//  BakeRoadOutlinedStyle.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import SwiftUI

enum BakeRoadOutlinedStyle {
    case primary
    case secondary
    case assistive
    
    func textColor(isDisabled: Bool) -> Color {
        switch self {
        case .primary:
            return isDisabled ? .gray200 : .primary500
        case .secondary:
            return isDisabled ? .gray200 : .primary500
        case .assistive:
            return isDisabled ? .gray200 : .gray990
        }
    }
    
    func borderColor(isDisabled: Bool) -> Color {
        switch self {
        case .primary:
            return isDisabled ? .gray200 : .primary500
        case .secondary:
            return .gray200
        case .assistive:
            return isDisabled ? .gray100 : .gray200
        }
    }
}
