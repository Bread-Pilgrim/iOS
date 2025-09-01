//
//  BadgeRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import Foundation

protocol BadgeRepository {
    func getBadgeList() async throws -> [Badge]
}
