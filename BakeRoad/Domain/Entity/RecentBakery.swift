//
//  RecentBakery.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

struct RecentBakery: Identifiable {
    let id: Int
    let name: String
    let openStatus: String
    let imgUrl: String
    let avgRating: Double
    let reviewCount: Int    
    let commercialAreaId: Int
}
