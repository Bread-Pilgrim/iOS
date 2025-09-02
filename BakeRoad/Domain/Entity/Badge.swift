//
//  Badge.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import Foundation

struct Badge: Identifiable {
    let id: Int
    let name: String
    let description: String
    let imgUrl: String
    let isEarned: Bool
    let isRepresentative: Bool
}
