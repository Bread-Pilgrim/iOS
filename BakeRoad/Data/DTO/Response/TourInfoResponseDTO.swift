//
//  TourInfoResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

typealias TourListResponseDTO = [TourInfoResponseDTO]

struct TourInfoResponseDTO: Codable {
    let title: String
    let tourType: String
    let address: String
    let tourImg: String
    let mapx: Double
    let mapy: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case tourType = "tour_type"
        case address
        case tourImg = "tour_img"
        case mapx
        case mapy
    }
}

extension TourInfoResponseDTO {
    func toEntity() -> TourInfo {
        TourInfo(
            title: title,
            address: address,
            imageUrl: tourImg,
            categoryName: tourType
        )
    }
}
