//
//  TourInfo.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

struct TourInfo: Identifiable {
    let id = UUID()
    let title: String
    let address: String
    let imageUrl: String
    let categoryName: String
    let mapx: Double
    let mapy: Double
}
