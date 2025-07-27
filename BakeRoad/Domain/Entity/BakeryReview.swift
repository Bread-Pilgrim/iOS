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
    let content: String
    let rating: Double
    let averageRating: Double
    let createdAt: String
    let isLiked: Bool
    let likeCount: Int
    let menus: [String]
    let photoURLs: [String]
}

struct Pagination {
    let nextCursor: String?
    let hasNext: Bool
}

extension BakeryReview {
    static let mock: BakeryReview = BakeryReview(
        id: 1,
        userName: "빵순이",
        profileImageURL: "https://example.com/profile1.jpg",
        content: "빵이 정말 맛있어요! 특히 크루아상이 최고였어요.",
        rating: 4.5,
        averageRating: 4.3,
        createdAt: "2025-07-25T14:32:00Z",
        isLiked: true,
        likeCount: 12,
        menus: ["크루아상", "소금빵"],
        photoURLs: [
            "https://example.com/review1_photo1.jpg",
            "https://example.com/review1_photo2.jpg"
        ]
    )
    
    static let mock2: BakeryReview = BakeryReview(
        id: 2,
        userName: "빵돌이",
        profileImageURL: nil,
        content: "분위기도 좋고 빵도 다양해서 자주 갈 것 같아요.",
        rating: 5.0,
        averageRating: 4.8,
        createdAt: "2025-07-20T10:15:00Z",
        isLiked: false,
        likeCount: 3,
        menus: ["앙버터", "에그타르트"],
        photoURLs: []
    )
    
    static let mocks: [BakeryReview] = [mock, mock2]
}
