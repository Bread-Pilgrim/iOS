//
//  BakeryType.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

enum BakeryType: String {
    case preference
    case hot
    
    var recommendEndpoint: String {
        switch self {
        case .preference:
            return BakeryEndPoint.recommendPreference
        case .hot:
            return BakeryEndPoint.recommendHot
        }
    }
    
    var listEndPoint: String {
        switch self {
        case .preference:
            return BakeryEndPoint.listPreference
        case .hot:
            return BakeryEndPoint.listHot
        }
    }
}
