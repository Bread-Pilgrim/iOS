//
//  Area.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

struct Area {
    let code: Int
    let name: String
}

extension Area: Identifiable {
    var id: Int { code }
}
