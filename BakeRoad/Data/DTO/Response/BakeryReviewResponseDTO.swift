//
//  BakeryReviewResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import Foundation

struct BakeryReviewResponseDTO: Decodable {
    let items: [ReviewItemDTO]
    let paging: PagingDTO
}

struct ReviewItemDTO: Decodable {
    let avgRating: Double
    let userName: String
    let profileImg: String?
    let isLike: Bool
    let reviewId: Int
    let reviewContent: String
    let reviewRating: Double
    let reviewLikeCount: Int
    let reviewCreatedAt: String
    let reviewMenus: [ReviewMenuDTO]?
    let reviewPhotos: [ReviewPhotoDTO]?
}

struct ReviewMenuDTO: Decodable {
    let menuName: String
}

struct ReviewPhotoDTO: Decodable {
    let imgUrl: String
}

struct PagingDTO: Decodable {
    let nextCursor: String?
    let hasNext: Bool
}
