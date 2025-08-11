//
//  APIError.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

enum APIError: Error {
    case serverError(code: Int, message: String)
    case emptyData
    case decoding
    case network(Error)
}
