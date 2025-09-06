//
//  TourRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

protocol TourRepository {
    func getTourList(areaCodes: String, tourCatCodes: String) async throws -> [TourInfo]
    func getTourEvent(_ areaCodes: String) async throws -> EventPopup
}
