//
//  APIError.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import Foundation

enum APIError: Error {
    case serverError(message: String)
    case emptyData
}
