//
//  Encodable+Extensions.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}
