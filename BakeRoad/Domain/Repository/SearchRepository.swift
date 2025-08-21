//
//  SearchRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

protocol SearchRepository {
    func getSerachBakeries(_ requestDTO: SearchBakeryRequestDTO) async throws -> Page<Bakery>
}
