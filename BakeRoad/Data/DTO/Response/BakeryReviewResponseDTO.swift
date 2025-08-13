//
//  BakeryReviewResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import Foundation

struct BakeryReviewResponseDTO: Decodable {
    let avgRating: Double
    let reviewCount: Int
    let reviews: [BakeryReviewDTO]
    let hasNext: Bool
    
    struct BakeryReviewDTO: Decodable {
        let userName: String
        let profileImg: String?
        let isLike: Bool
        let reviewId: Int
        let reviewContent: String
        let reviewRating: Double
        let reviewLikeCount: Int
        let reviewCreatedAt: String
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
            case userName = "user_name"
            case profileImg = "profile_img"
            case isLike = "is_like"
            case reviewId = "review_id"
            case reviewContent = "review_content"
            case reviewRating = "review_rating"
            case reviewLikeCount = "review_like_count"
            case reviewCreatedAt = "review_created_at"
            case reviewMenus = "review_menus"
            case reviewPhotos = "review_photos"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case avgRating = "avg_rating"
        case reviewCount = "review_count"
        case reviews
        case hasNext = "has_next"
    }
}

extension BakeryReviewResponseDTO.BakeryReviewDTO {
    func toEntity() -> BakeryReview {
        BakeryReview(
            id: reviewId,
            userName: userName,
            profileImageURL: profileImg,
            isLike: isLike,
            content: reviewContent,
            rating: reviewRating,
            likeCount: reviewLikeCount,
            createdAt: reviewCreatedAt,
            menus: (reviewMenus ?? []).map { $0.menuName },
            photos: (reviewPhotos ?? []).map { $0.imgUrl }
        )
    }
}
