//
//  BakeryReview.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import Foundation

struct BakeryReview: Identifiable, Equatable {
    let id: Int
    let userName: String
    let profileImageURL: String?
    let isLike: Bool
    let content: String
    let rating: Double
    let likeCount: Int
    let createdAt: String
    let menus: [String]
    let photos: [String]
}

struct BakeryReviewData: Equatable {
    let avgRating: Double
    let reviewCount: Int
}

struct BakeryReviewPage {
    let page: Page<BakeryReview>
    let data: BakeryReviewData?
}
