//
//  BakeRoadButton+Size.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import SwiftUI

enum BakeRoadButtonSize {
    case xsmall, small, medium, large, xlarge
    
    var font: Font {
        switch self {
        case .xsmall: return .body2xsmallMedium
        case .small: return .body2xsmallSemibold
        case .medium: return .bodySmallSemibold
        case .large: return .bodyMediumSemibold
        case .xlarge: return .bodyLargeSemibold
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .xsmall: return 5
        case .small: return 7
        case .medium: return 9.5
        case .large: return 13
        case .xlarge: return 15.5
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .xsmall: return 10
        case .small: return 12
        case .medium: return 16
        case .large: return 24
        case .xlarge: return 36
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .xsmall, .small: return 4
        case .medium: return 5
        case .large, .xlarge: return 6
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .xsmall: return 4
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        case .xlarge: return 12
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .xsmall, .small: return 16
        case .medium: return 18
        case .large, .xlarge: return 20
        }
    }
}
