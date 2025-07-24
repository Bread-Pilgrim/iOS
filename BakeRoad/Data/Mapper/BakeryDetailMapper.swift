//
//  BakeryDetailMapper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/24/25.
//

import Foundation

enum BakeryDetailMapper {
    static func map(from dto: BakeryDetailResponseDTO) -> BakeryDetail {
        return BakeryDetail(
            id: dto.bakeryId,
            name: dto.bakeryName,
            address: dto.address,
            phone: dto.phone,
            rating: dto.avgRating,
            reviewCount: dto.reviewCount,
            openStatus: BakeryOpenStatus(rawValue: dto.openStatus) ?? .open,
            operatingHours: (dto.operatingHours ?? []).map {
                BakeryDetail.OperatingHour(
                    dayOfWeek: $0.dayOfWeek,
                    openTime: $0.openTime,
                    closeTime: $0.closeTime,
                    isOpened: $0.isOpened
                )
            },
            isLike: dto.isLike,
            imageUrls: dto.bakeryImgUrls ?? [],
            menus: (dto.menus ?? []).map {
                BakeryDetail.BakeryMenu(
                    name: $0.name,
                    price: $0.price,
                    isSignature: $0.isSignature,
                    imageUrl: $0.imageUrl
                )
            }
        )
    }
}
