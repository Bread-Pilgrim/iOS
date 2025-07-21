//
//  RecommendRecommendBakery.swift
//  BakeRoad
//
//  Created by 이현호 on 7/21/25.
//

import Foundation

struct RecommendBakery {
    let id: Int
    let name: String
    let avgRating: Double
    let reviewCount: Int
    let openStatus: String
    let imgUrl: String
    let isLike: Bool
}

extension RecommendBakery {
    static let mockData: [RecommendBakery] = [
        RecommendBakery(id: 1, name: "이흥용과자점", avgRating: 4.8, reviewCount: 1234, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,1", isLike: true),
        RecommendBakery(id: 2, name: "빵의정석", avgRating: 4.3, reviewCount: 845, openStatus: "C", imgUrl: "https://source.unsplash.com/116x116/?bread,2", isLike: false),
        RecommendBakery(id: 3, name: "크로와상하우스", avgRating: 4.6, reviewCount: 976, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,3", isLike: false),
        RecommendBakery(id: 4, name: "몽슈슈", avgRating: 4.7, reviewCount: 1345, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,4", isLike: true),
        RecommendBakery(id: 5, name: "파리크라상", avgRating: 4.1, reviewCount: 623, openStatus: "C", imgUrl: "https://source.unsplash.com/116x116/?bread,5", isLike: false),
        RecommendBakery(id: 6, name: "우리동네빵집", avgRating: 4.5, reviewCount: 382, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,6", isLike: true),
        RecommendBakery(id: 7, name: "식빵전문점", avgRating: 4.2, reviewCount: 700, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,7", isLike: false),
        RecommendBakery(id: 8, name: "더브레드블루", avgRating: 4.9, reviewCount: 2153, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,8", isLike: true),
        RecommendBakery(id: 9, name: "빵지순례", avgRating: 4.6, reviewCount: 1422, openStatus: "C", imgUrl: "https://source.unsplash.com/116x116/?bread,9", isLike: false),
        RecommendBakery(id: 10, name: "크림빵제과점", avgRating: 4.4, reviewCount: 891, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,10", isLike: false),
        RecommendBakery(id: 11, name: "청년제과", avgRating: 4.3, reviewCount: 648, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,11", isLike: true),
        RecommendBakery(id: 12, name: "소보루당", avgRating: 4.5, reviewCount: 512, openStatus: "C", imgUrl: "https://source.unsplash.com/116x116/?bread,12", isLike: false),
        RecommendBakery(id: 13, name: "대장장이빵집", avgRating: 4.7, reviewCount: 1650, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,13", isLike: true),
        RecommendBakery(id: 14, name: "버터앤밀크", avgRating: 4.6, reviewCount: 731, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,14", isLike: false),
        RecommendBakery(id: 15, name: "고메베이커리", avgRating: 4.9, reviewCount: 1933, openStatus: "C", imgUrl: "https://source.unsplash.com/116x116/?bread,15", isLike: true),
        RecommendBakery(id: 16, name: "하루한빵", avgRating: 4.1, reviewCount: 412, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,16", isLike: false),
        RecommendBakery(id: 17, name: "퍼스트브레드", avgRating: 4.4, reviewCount: 784, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,17", isLike: true),
        RecommendBakery(id: 18, name: "청춘빵집", avgRating: 4.2, reviewCount: 321, openStatus: "C", imgUrl: "https://source.unsplash.com/116x116/?bread,18", isLike: false),
        RecommendBakery(id: 19, name: "동네제과점", avgRating: 4.0, reviewCount: 285, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,19", isLike: true),
        RecommendBakery(id: 20, name: "월간빵집", avgRating: 4.6, reviewCount: 1103, openStatus: "O", imgUrl: "https://source.unsplash.com/116x116/?bread,20", isLike: false)
    ]
}
