//
//  CURLLogger.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

import Alamofire

final class CURLLogger: EventMonitor {
    func requestDidFinish(_ request: Request) {
        guard let urlRequest = request.request else { return }
        print("🔥 CURL Command:")
        print(urlRequest.cURL())
        print("🔥 End CURL")
    }
}

extension URLRequest {
    func cURL() -> String {
        guard let url = url else { return "" }
        
        var curlCommand = "curl -X \(httpMethod ?? "GET") \\\n"
        curlCommand += "'\(url.absoluteString)' \\\n"
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                curlCommand += "-H '\(key): \(value)' \\\n"
            }
        }
        
        if let httpBody = httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            curlCommand += "-d '\(bodyString)'"
        }
        
        return curlCommand
    }
}
