//
//  BakeryReviewMapper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import Foundation

enum BakeryReviewMapper {
    static func map(from dto: ReviewItemDTO) -> BakeryReview {
        return BakeryReview(
            id: dto.reviewId,
            userName: dto.userName,
            profileImageURL: dto.profileImg,
            content: dto.reviewContent,
            rating: dto.reviewRating,
            averageRating: dto.avgRating,
            createdAt: dto.reviewCreatedAt,
            isLiked: dto.isLike,
            likeCount: dto.reviewLikeCount,
            menus: dto.reviewMenus?.map { $0.menuName } ?? [],
            photoURLs: dto.reviewPhotos?.map { $0.imgUrl } ?? []
        )
    }
    
    static func map(from dto: PagingDTO) -> Pagination {
        return Pagination(
            nextCursor: dto.nextCursor,
            hasNext: dto.hasNext
        )
    }
}
