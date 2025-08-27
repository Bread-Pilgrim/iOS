//
//  BreadReportListItem.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

struct BreadReportListItem : Identifiable, Equatable {
    var id: String { "\(year)년 \(month)월" }
    let year: Int
    let month: Int
}
