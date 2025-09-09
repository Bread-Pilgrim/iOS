//
//  BreadReportListItem.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

struct BreadReportListItem : Identifiable, Equatable, Hashable {
    var id: String { "\(year)년 \(month)월" }
    let year: Int
    let month: Int
}

extension BreadReportListItem {
    func toRequestDTO() -> BreadReportRequestDTO {
        return BreadReportRequestDTO(year: year, month: month)
    }
    
    func previousMonth() -> BreadReportListItem {
        let prevYear = month == 1 ? year - 1 : year
        let prevMonth = month == 1 ? 12 : month - 1
        return BreadReportListItem(year: prevYear, month: prevMonth)
    }
    
    func nextMonth() -> BreadReportListItem {
        let nextYear = month == 12 ? year + 1 : year
        let nextMonth = month == 12 ? 1 : month + 1
        return BreadReportListItem(year: nextYear, month: nextMonth)
    }
}
