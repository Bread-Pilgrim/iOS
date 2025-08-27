//
//  BreadReportResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

struct BreadReportResponseDTO: Decodable {
    let year: Int
    let month: Int
    let visitedAreas: [String: Int]
    let breadTypes: [String: Int]
    let dailyAvgQuantity: Double
    let monthlyConsumptionGap: Double
    let totalQuantity: Int
    let totalVisitCount: Int
    let totalPrices: [Int]
    let weeklyDistribution: [String: Int]
    let reviewCount: Int
    let likedCount: Int
    let receivedLikesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case year
        case month
        case visitedAreas = "visited_areas"
        case breadTypes = "bread_types"
        case dailyAvgQuantity = "daily_avg_quantity"
        case monthlyConsumptionGap = "monthly_consumption_gap"
        case totalQuantity = "total_quantity"
        case totalVisitCount = "total_visit_count"
        case totalPrices = "total_prices"
        case weeklyDistribution = "weekly_distribution"
        case reviewCount = "review_count"
        case likedCount = "liked_count"
        case receivedLikesCount = "received_likes_count"
    }
}

extension BreadReportResponseDTO {
    func toEntity() -> BreadReport {
        BreadReport(
            year: year,
            month: month,
            visitedAreas: visitedAreas,
            breadTypes: breadTypes,
            dailyAvgQuantity: dailyAvgQuantity,
            monthlyConsumptionGap: monthlyConsumptionGap,
            totalQuantity: totalQuantity,
            totalVisitCount: totalVisitCount,
            totalPrices: totalPrices,
            weeklyDistribution: weeklyDistribution,
            reviewCount: reviewCount,
            likedCount: likedCount,
            receivedLikesCount: receivedLikesCount
        )
    }
}
