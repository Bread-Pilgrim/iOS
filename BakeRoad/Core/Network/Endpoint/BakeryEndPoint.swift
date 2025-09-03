//
//  BakeryEndPoint.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

enum BakeryEndPoint {
    static let recommendPreference = "/bakeries/recommend/preference"
    static let recommendHot = "/bakeries/recommend/hot"
    static let listPreference = "/bakeries/preference"
    static let listHot = "/bakeries/hot"
    static let listVisited = "/bakeries/visited"
    static let listLike = "/bakeries/like"
    static let listRecent = "/bakeries/recent"
    
    static func detail(_ id: Int) -> String {
        return "/bakeries/\(id)"
    }
    static func menus(_ id: Int) -> String {
        return "/bakeries/\(id)/menus"
    }
    static func reviews(_ id: Int) -> String {
        return "/bakeries/\(id)/reviews"
    }
    static func myReview(_ id: Int) -> String {
        return "/bakeries/\(id)/my-review"
    }
    static func canReview(_ id: Int) -> String {
        return "/bakeries/\(id)/review/eligibility"
    }
    static func like(_ id: Int) -> String {
        return "/bakeries/\(id)/like"
    }
    static func dislike(_ id: Int) -> String {
        return "/bakeries/\(id)/like"
    }
    static func writeReview(_ id: Int) -> String {
        return "/bakeries/\(id)/reviews"
    }
}
