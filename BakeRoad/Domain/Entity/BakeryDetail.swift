//
//  BakeryDetail.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import Foundation

struct BakeryDetail: Equatable {
    let id: Int
    let name: String
    let address: String
    let phone: String?
    let rating: Double
    let reviewCount: Int
    let openStatus: BakeryOpenStatus
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

extension BakeryDetail {
    static let mockData = BakeryDetail(
        id: 1,
        name: "서라당",
        address: "서울시 관악구 신사로 120-1 1층 서라당",
        phone: "010-1234-5678",
        rating: 4.7,
        reviewCount: 10023,
        openStatus: .open,
        operatingHours: [
            OperatingHour(dayOfWeek: 0, openTime: "10:00", closeTime: "20:00", isOpened: true),
            OperatingHour(dayOfWeek: 1, openTime: "10:00", closeTime: "20:00", isOpened: true),
            OperatingHour(dayOfWeek: 2, openTime: "10:00", closeTime: "20:00", isOpened: true),
            OperatingHour(dayOfWeek: 3, openTime: "10:00", closeTime: "20:00", isOpened: true),
            OperatingHour(dayOfWeek: 4, openTime: "10:00", closeTime: "20:00", isOpened: true),
            OperatingHour(dayOfWeek: 5, openTime: "10:00", closeTime: "20:00", isOpened: true),
            OperatingHour(dayOfWeek: 6, openTime: "", closeTime: "", isOpened: false)
        ],
        isLike: false,
        imageUrls: [
            "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4", // 대표 이미지
            "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
            "https://images.unsplash.com/photo-1578985545062-69928b1d9587"
        ],
        menus: [
            BakeryDetail.BakeryMenu(
                name: "바닐라 크림 케이크",
                price: 4500,
                isSignature: true,
                imageUrl: nil
            ),
            BakeryDetail.BakeryMenu(
                name: "마카롱 세트",
                price: 12000,
                isSignature: false,
                imageUrl: nil
            )
        ]
    )
}
