//
//  ReviewRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

protocol ReviewRepository {
    func postReviewLike(_ id: Int) async throws
    func deleteReviewLike(_ id: Int) async throws
}
