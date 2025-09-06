//
//  WriteReviewRequestDTO.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation

struct WriteReviewRequestDTO: Encodable {
    let rating: Double
    let content: String
    let isPrivate: Bool
    let consumedMenus: String
    let reviewImgs: [String]?
    
    enum CodingKeys: String, CodingKey {
        case rating
        case content
        case isPrivate = "is_private"
        case consumedMenus = "consumed_menus"
        case reviewImgs = "review_imgs"
    }
    
    init(rating: Double, content: String, isPrivate: Bool, menus: [ConsumedMenu], imageUrls: [String]?) {
        self.rating = rating
        self.content = content
        self.isPrivate = isPrivate
        self.reviewImgs = imageUrls
        
        // menus를 JSON 문자열로 변환
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(menus),
           let jsonString = String(data: data, encoding: .utf8) {
            self.consumedMenus = jsonString
        } else {
            self.consumedMenus = "[]"
        }
    }
}

struct ConsumedMenu: Encodable {
    let menuId: Int
    let quantity: Int
    let breadTypeID: Int
    
    enum CodingKeys: String, CodingKey {
        case menuId = "menu_id"
        case quantity
        case breadTypeID = "bread_type_id"
    }
}
