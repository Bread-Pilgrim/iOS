//
//  APIService.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import Alamofire

public final class APIService {
    public static let shared = APIService()

    private let session: Session
    private let baseURL: String = AppConstant.baseURL

    private init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }
}
