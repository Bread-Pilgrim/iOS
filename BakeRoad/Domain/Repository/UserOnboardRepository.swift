//
//  UserOnboardRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/5/25.
//

import Foundation

protocol UserOnboardRepository {
    func postUserOnboard(_ dto: UserOnboardRequestDTO) async throws
}
