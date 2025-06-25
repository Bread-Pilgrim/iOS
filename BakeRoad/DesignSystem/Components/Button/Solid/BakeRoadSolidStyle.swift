//
//  BakeRoadSolidStyle.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import SwiftUI

enum BakeRoadSolidStyle {
    case primary
    case secondary
    
    func textColor(isDisabled: Bool) -> Color {
        switch self {
        case .primary:
            return isDisabled ? .gray300 : .white
        case .secondary:
            return isDisabled ? .primary200 : .primary500
        }
    }
    
    func backgroundColor(isDisabled: Bool) -> Color {
        switch self {
        case .primary:
            return isDisabled ? .gray50 : .primary500
        case .secondary:
            return isDisabled ? .primary50 : .primary100
        }
    }
}
