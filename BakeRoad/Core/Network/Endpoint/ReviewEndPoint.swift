//
//  ReviewEndPoint.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

enum ReviewEndPoint {
    static func like(_ id: Int) -> String {
        return "/reviews/\(id)/like"
    }
    static func dislike(_ id: Int) -> String {
        return "/reviews/\(id)/like"
    }
}
