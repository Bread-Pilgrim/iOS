//
//  GetNoticeResponseDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

struct GetNoticeResponseDTO: Decodable {
    let notice_id: Int
    let notice_title: String
    let contents: [String]
}

extension GetNoticeResponseDTO {
    func toEntity() -> Notice {
        Notice(
            id: notice_id,
            title: notice_title,
            contents: contents
        )
    }
}
