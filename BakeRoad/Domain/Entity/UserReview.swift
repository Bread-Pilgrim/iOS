//
//  UserReview.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import Foundation

struct UserReview: Identifiable, Equatable {
    let id: Int
    let bakeryId: Int
    let bakeryName: String
    let reviewContent: String
    let reviewRating: Double
    let reviewLikeCount: Int
    let isLike: Bool
    let menus: [String]
    let photos: [String]
    
    func toggleLike() -> UserReview {
        return UserReview(
            id: id,
            bakeryId: bakeryId,
            bakeryName: bakeryName,
            reviewContent: reviewContent,
            reviewRating: reviewRating,
            reviewLikeCount: isLike ? reviewLikeCount - 1 : reviewLikeCount + 1,
            isLike: !isLike,
            menus: menus,
            photos: photos
        )
    }
}
