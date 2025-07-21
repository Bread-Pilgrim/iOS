//
//  Int+Extensions.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Foundation

extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
