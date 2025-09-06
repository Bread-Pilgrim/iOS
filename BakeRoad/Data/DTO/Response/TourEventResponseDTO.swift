//
//  TourEventResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 9/4/25.
//

import Foundation

struct TourEventResponseDTO: Decodable {
    let title: String
    let address: String
    let start_date: String
    let end_date: String
    let event_img: String
    let mapx: Double
    let mapy: Double
    let tel: String
    let read_more_link: String
}

extension TourEventResponseDTO {
    func toEntity() -> EventPopup {
        EventPopup(
            title: title,
            address: address,
            startDate: start_date,
            endDate: end_date,
            eventImg: event_img,
            mapx: mapx,
            mapy: mapy,
            tel: tel,
            readMoreLink: read_more_link
        )
    }
}
