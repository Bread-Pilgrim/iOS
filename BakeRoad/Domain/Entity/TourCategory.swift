//
//  TourCategory.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Foundation

enum TourCategory: String, CaseIterable {
    case nature = "A01"             // 자연
    case humanities = "A02"         // 인문
    case leisureSports = "A03"      // 레포츠
    case shopping = "A04"           // 쇼핑
    case recommendedCourse = "C01"  // 추천코스

    var title: String {
        switch self {
        case .nature:
            return "자연"
        case .humanities:
            return "인문"
        case .leisureSports:
            return "레포츠"
        case .shopping:
            return "쇼핑"
        case .recommendedCourse:
            return "추천코스"
        }
    }
}
