//
//  BreadReport.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import Foundation

struct BreadReport {
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
}
