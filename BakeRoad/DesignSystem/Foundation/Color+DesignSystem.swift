//
//  Color+DesignSystem.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import SwiftUI

extension Color {
    // MARK: - Primary
    static let primary50  = Color(hex: "#fff4ed")
    static let primary100 = Color(hex: "#ffe7d4")
    static let primary200 = Color(hex: "#ffcba8")
    static let primary300 = Color(hex: "#ffa670")
    static let primary400 = Color(hex: "#ff7537")
    static let primary500 = Color(hex: "#ff5e23")
    static let primary600 = Color(hex: "#f03506")
    static let primary700 = Color(hex: "#c72407")
    static let primary800 = Color(hex: "#9e1e0e")
    static let primary900 = Color(hex: "#771c0f")
    static let primary950 = Color(hex: "#450a05")
    
    // MARK: - Secondary
    static let secondary50  = Color(hex: "#eef7ff")
    static let secondary100 = Color(hex: "#daecff")
    static let secondary200 = Color(hex: "#bddfff")
    static let secondary300 = Color(hex: "#90cbff")
    static let secondary400 = Color(hex: "#6bb5ff")
    static let secondary500 = Color(hex: "#358bfc")
    static let secondary600 = Color(hex: "#1f6cf1")
    static let secondary700 = Color(hex: "#1755de")
    static let secondary800 = Color(hex: "#1946b4")
    static let secondary900 = Color(hex: "#1a3e8e")
    static let secondary950 = Color(hex: "#152756")
    
    // MARK: - Gray Scale
    static let gray40  = Color(hex: "#fafafa")
    static let gray50  = Color(hex: "#f6f6f6")
    static let gray100 = Color(hex: "#e7e7e7")
    static let gray200 = Color(hex: "#d1d1d1")
    static let gray300 = Color(hex: "#b0b0b0")
    static let gray400 = Color(hex: "#888888")
    static let gray500 = Color(hex: "#6d6d6d")
    static let gray600 = Color(hex: "#595959")
    static let gray700 = Color(hex: "#4f4f4f")
    static let gray800 = Color(hex: "#454545")
    static let gray900 = Color(hex: "#3d3d3d")
    static let gray950 = Color(hex: "#262626")
    static let gray990 = Color(hex: "#121212")
    
    // MARK: - Background & Default
    static let bg01 = Color(hex: "#fffbee")
    static let black = Color(hex: "#000000")
    static let white = Color(hex: "#ffffff")
    
    // MARK: - Opacity
    static let opacity80 = Color(hex: "#6d6d6d").opacity(0.8)
    static let opacity60 = Color(hex: "#6d6d6d").opacity(0.6)
    static let opacity40 = Color(hex: "#6d6d6d").opacity(0.4)
    static let opacity20 = Color(hex: "#6d6d6d").opacity(0.2)
    static let opacity10 = Color(hex: "#6d6d6d").opacity(0.1)
    static let opacity6  = Color(hex: "#6d6d6d").opacity(0.06)
    
    // MARK: - Success
    static let success50  = Color(hex: "#eefff2")
    static let success100 = Color(hex: "#d7ffe4")
    static let success200 = Color(hex: "#b2ffca")
    static let success300 = Color(hex: "#76ffa2")
    static let success400 = Color(hex: "#33f573")
    static let success500 = Color(hex: "#09de50")
    static let success600 = Color(hex: "#00bf40")
    static let success700 = Color(hex: "#049134")
    static let success800 = Color(hex: "#0a712e")
    static let success900 = Color(hex: "#0a5d28")
    static let success950 = Color(hex: "#003413")
    
    // MARK: - Error
    static let error50  = Color(hex: "#fff1f1")
    static let error100 = Color(hex: "#ffdfdf")
    static let error200 = Color(hex: "#ffc5c5")
    static let error300 = Color(hex: "#ff9d9d")
    static let error400 = Color(hex: "#ff6464")
    static let error500 = Color(hex: "#ff2e2e")
    static let error600 = Color(hex: "#ed1515")
    static let error700 = Color(hex: "#c80d0d")
    static let error800 = Color(hex: "#a50f0f")
    static let error900 = Color(hex: "#881414")
    static let error950 = Color(hex: "#4b0404")
    
    // MARK: - Positive
    static let positive50  = Color(hex: "#edf8ff")
    static let positive100 = Color(hex: "#d6efff")
    static let positive200 = Color(hex: "#b5e4ff")
    static let positive300 = Color(hex: "#83d5ff")
    static let positive400 = Color(hex: "#48bcff")
    static let positive500 = Color(hex: "#1e9aff")
    static let positive600 = Color(hex: "#067aff")
    static let positive700 = Color(hex: "#0066ff")
    static let positive800 = Color(hex: "#084ec5")
    static let positive900 = Color(hex: "#0d469b")
    static let positive950 = Color(hex: "#0e2b5d")
}

extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}
