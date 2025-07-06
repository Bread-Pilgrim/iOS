//
//  FontStyle.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import UIKit
import SwiftUI

enum FontStyle {
    // Heading
    case headingLargeBold      // 22, Bold
    case headingMediumBold     // 20, Bold
    case headingSmallBold      // 18, Bold

    // Body - Semibold
    case bodyXlargeSemibold    // 20, SemiBold
    case bodyLargeSemibold     // 18
    case bodyMediumSemibold    // 16
    case bodySmallSemibold     // 15
    case bodyXsmallSemibold    // 14
    case body2xsmallSemibold   // 13

    // Body - Medium
    case bodyXlargeMedium      // 20
    case bodyLargeMedium       // 18
    case bodyMediumMedium      // 16
    case bodySmallMedium       // 15
    case bodyXsmallMedium      // 14
    case body2xsmallMedium     // 13

    // Body - Regular
    case bodyXlargeRegular     // 20
    case bodyLargeRegular      // 18
    case bodyMediumRegular     // 16
    case bodySmallRegular      // 15
    case bodyXsmallRegular     // 14
    case body2xsmallRegular    // 13

    var size: CGFloat {
        switch self {
        case .headingLargeBold: return 22
        case .headingMediumBold: return 20
        case .headingSmallBold: return 18
        case .bodyXlargeSemibold, .bodyXlargeMedium, .bodyXlargeRegular: return 20
        case .bodyLargeSemibold, .bodyLargeMedium, .bodyLargeRegular: return 18
        case .bodyMediumSemibold, .bodyMediumMedium, .bodyMediumRegular: return 16
        case .bodySmallSemibold, .bodySmallMedium, .bodySmallRegular: return 15
        case .bodyXsmallSemibold, .bodyXsmallMedium, .bodyXsmallRegular: return 14
        case .body2xsmallSemibold, .body2xsmallMedium, .body2xsmallRegular: return 13
        }
    }

    var fontName: String {
        switch self {
        case .headingLargeBold, .headingMediumBold, .headingSmallBold:
            return "Pretendard-Bold"
        case .bodyXlargeSemibold, .bodyLargeSemibold, .bodyMediumSemibold,
             .bodySmallSemibold, .bodyXsmallSemibold, .body2xsmallSemibold:
            return "Pretendard-SemiBold"
        case .bodyXlargeMedium, .bodyLargeMedium, .bodyMediumMedium,
             .bodySmallMedium, .bodyXsmallMedium, .body2xsmallMedium:
            return "Pretendard-Medium"
        case .bodyXlargeRegular, .bodyLargeRegular, .bodyMediumRegular,
             .bodySmallRegular, .bodyXsmallRegular, .body2xsmallRegular:
            return "Pretendard-Regular"
        }
    }

    var font: UIFont {
        return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
    }

    var lineHeight: CGFloat {
        return size * 1.4
    }
}

extension Font {
    // Heading
    static let headingLargeBold = Font.custom("Pretendard-Bold", size: 22)
    static let headingMediumBold = Font.custom("Pretendard-Bold", size: 20)
    static let headingSmallBold = Font.custom("Pretendard-Bold", size: 18)

    // Body - Semibold
    static let bodyXlargeSemibold = Font.custom("Pretendard-SemiBold", size: 20)
    static let bodyLargeSemibold = Font.custom("Pretendard-SemiBold", size: 18)
    static let bodyMediumSemibold = Font.custom("Pretendard-SemiBold", size: 16)
    static let bodySmallSemibold = Font.custom("Pretendard-SemiBold", size: 15)
    static let bodyXsmallSemibold = Font.custom("Pretendard-SemiBold", size: 14)
    static let body2xsmallSemibold = Font.custom("Pretendard-SemiBold", size: 13)

    // Body - Medium
    static let bodyXlargeMedium = Font.custom("Pretendard-Medium", size: 20)
    static let bodyLargeMedium = Font.custom("Pretendard-Medium", size: 18)
    static let bodyMediumMedium = Font.custom("Pretendard-Medium", size: 16)
    static let bodySmallMedium = Font.custom("Pretendard-Medium", size: 15)
    static let bodyXsmallMedium = Font.custom("Pretendard-Medium", size: 14)
    static let body2xsmallMedium = Font.custom("Pretendard-Medium", size: 13)

    // Body - Regular
    static let bodyXlargeRegular = Font.custom("Pretendard-Regular", size: 20)
    static let bodyLargeRegular = Font.custom("Pretendard-Regular", size: 18)
    static let bodyMediumRegular = Font.custom("Pretendard-Regular", size: 16)
    static let bodySmallRegular = Font.custom("Pretendard-Regular", size: 15)
    static let bodyXsmallRegular = Font.custom("Pretendard-Regular", size: 14)
    static let body2xsmallRegular = Font.custom("Pretendard-Regular", size: 13)
}
