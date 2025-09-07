//
//  BakeryRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

protocol BakeryRepository {
    func getRecommendBakeries(_ type: BakeryType, areaCode: String) async throws -> [RecommendBakery]
    func getBakeryList(_ type: BakeryType, requestDTO: BakeryListRequestDTO) async throws -> Page<Bakery>
    func getBakeryDetail(_ id: Int) async throws -> BakeryDetail
    func getBakeryMenus(_ id: Int) async throws -> [BakeryMenu]
    func getBakeryReviews(_ id: Int, requestDTO: BakeryReviewRequestDTO) async throws -> BakeryReviewPage
    func getBakeryMyReviews(_ id: Int, requestDTO: BakeryMyReviewRequestDTO) async throws -> Page<BakeryReview>
    func postBakeryLike(_ id: Int) async throws
    func deleteBakeryLike(_ id: Int) async throws
    func getBakeryReviewEligibility(_ id: Int) async throws -> BakeryReviewEligibilityResponseDTO
    func writeReview(_ id: Int, requestDTO: WriteReviewRequestDTO, imageData: [Data]) async throws -> [Badge]?
    func getMyBakeryList(_ type: MyBakeryType, requestDTO: BakeryMyListRequestDTO) async throws -> Page<Bakery>
    func getRecentBakeryList() async throws -> [RecommendBakery]
    func deleteRecentBakeryList() async throws
}
