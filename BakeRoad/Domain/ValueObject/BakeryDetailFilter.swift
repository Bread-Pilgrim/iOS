//
//  BakeryDetailFilter.swift
//  BakeRoad
//
//  Created by 이현호 on 8/16/25.
//

import Foundation

struct BakeryDetailFilter: Hashable {
    let bakeryId: Int
    let areaCodes: Set<Int>
    let tourCatCodes: Set<String>
}
