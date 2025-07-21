//
//  BakeryOpenStatusChip.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import SwiftUI

enum BakeryOpenStatus: String {
    case open = "O"
    case close = "C"
    case dayOff = "D"
    
    var displayName: String {
        switch self {
        case .open:
            return "영업중"
        case .close:
            return "영업종료"
        case .dayOff:
            return "오늘 휴무"
        }
    }
}

struct BakeryOpenStatusChip: View {
    let openStatus: BakeryOpenStatus?
    let style: ChipStyle
    
    var body: some View {
        let status = openStatus ?? .open
        
        BakeRoadChip(
            title: status.displayName,
            color: status == .open ? .main : .lightGray,
            size: .small,
            style: style
        )
    }
}
