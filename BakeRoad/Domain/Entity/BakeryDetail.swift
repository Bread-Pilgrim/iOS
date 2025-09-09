//
//  BakeryDetail.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import Foundation

struct BakeryDetail: Equatable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let phone: String?
    let openStatus: BakeryOpenStatus
    let mapy: Double
    let mapx: Double
    let operatingHours: [OperatingHour]
    let isLike: Bool
    let imageUrls: [String]
    let menus: [BakeryMenu]
    
    struct OperatingHour: Equatable {
        let dayOfWeek: Int
        let openTime: String
        let closeTime: String
        let isOpened: Bool
        
        var displayDayString: String {
            switch dayOfWeek {
            case 0: return "월"
            case 1: return "화"
            case 2: return "수"
            case 3: return "목"
            case 4: return "금"
            case 5: return "토"
            case 6: return "일"
            default: return "월"
            }
        }
    }
    
    struct BakeryMenu: Equatable, Identifiable {
        let id = UUID()
        let name: String
        let price: Int
        let isSignature: Bool
        let imageUrl: String?
    }
}

extension BakeryDetail {
    func toggleLike() -> BakeryDetail {
        return BakeryDetail(
            id: self.id,
            name: self.name,
            address: self.address,
            phone: self.phone,
            openStatus: self.openStatus,
            mapy: self.mapy,
            mapx: self.mapx,
            operatingHours: self.operatingHours,
            isLike: !self.isLike,
            imageUrls: self.imageUrls,
            menus: self.menus
        )
    }
}

extension Array where Element == BakeryDetail.OperatingHour {
    func sortedByWeekday() -> [BakeryDetail.OperatingHour] {
        let order: [Int] = [0, 1, 2, 3, 4, 5, 6]
        return self.sorted {
            guard let lhsIndex = order.firstIndex(of: $0.dayOfWeek),
                  let rhsIndex = order.firstIndex(of: $1.dayOfWeek) else {
                return false
            }
            return lhsIndex < rhsIndex
        }
    }
    
    func closedDaysLabel() -> String {
        let closedDays = self
            .filter { $0.isOpened == false }
            .map { $0.displayDayString + "요일" }
        
        if closedDays.isEmpty {
            return "휴무 없음"
        } else {
            return closedDays.joined(separator: ", ") + " 휴무"
        }
    }
}
