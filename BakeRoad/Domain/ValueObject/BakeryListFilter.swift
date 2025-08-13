//
//  BakeryListFilter.swift
//  BakeRoad
//
//  Created by 이현호 on 8/12/25.
//

import Foundation

struct BakeryListFilter: Hashable {
    let type: BakeryType
    let areaCodes: Set<Int>
}
