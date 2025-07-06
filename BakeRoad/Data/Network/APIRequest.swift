//
//  APIRequest.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct APIRequest {
    let path: String
    let method: HTTPMethodType
    let parameters: Encodable?
    
    init(path: String, method: HTTPMethodType, parameters: Encodable? = nil) {
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}
