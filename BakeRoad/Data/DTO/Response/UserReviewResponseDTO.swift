//
//  UserReviewResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import Foundation

struct UserReviewResponseDTO: Decodable {
    let reviews: [UserReviewDTO]
    let nextCursor: String?
    
    private enum CodingKeys: String, CodingKey {
        case reviews = "items"
        case nextCursor = "next_cursor"
    }
}

struct UserReviewDTO: Decodable {
    let reviewId: Int
    let bakeryId: Int
    let bakeryName: String
    let reviewContent: String
    let reviewRating: Double
    let reviewLikeCount: Int
    let reviewCreatedAt: String
    let isLike: Bool
    let reviewMenus: [MenuDTO]?
    let reviewPhotos: [PhotoDTO]?
    
    struct MenuDTO: Decodable {
        let menuName: String
        
        private enum CodingKeys: String, CodingKey {
            case menuName = "menu_name"
        }
    }
    
    struct PhotoDTO: Decodable {
        let imgUrl: String
        
        private enum CodingKeys: String, CodingKey {
            case imgUrl = "img_url"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
        case bakeryId = "bakery_id"
        case bakeryName = "bakery_name"
        case reviewContent = "review_content"
        case reviewRating = "review_rating"
        case reviewLikeCount = "review_like_count"
        case reviewCreatedAt = "review_created_at"
        case isLike = "is_like"
        case reviewMenus = "review_menus"
        case reviewPhotos = "review_photos"
    }
}

extension UserReviewDTO {
    func toEntity() -> UserReview {
        UserReview(
            id: reviewId,
            bakeryId: bakeryId,
            bakeryName: bakeryName,
            reviewContent: reviewContent,
            reviewRating: reviewRating,
            reviewLikeCount: reviewLikeCount,
            reviewCreatedAt: reviewCreatedAt,
            isLike: isLike,
            menus: (reviewMenus ?? []).map { $0.menuName },
            photos: (reviewPhotos ?? []).map { $0.imgUrl }
        )
    }
}
