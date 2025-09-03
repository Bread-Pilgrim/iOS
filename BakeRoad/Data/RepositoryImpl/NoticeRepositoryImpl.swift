//
//  NoticeRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

final class NoticeRepositoryImpl: NoticeRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getNotice() async throws -> [Notice] {
        let request = APIRequest(
            path: NoticeEndPoint.getNotices,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: [GetNoticeResponseDTO].self)

        return dto.map { $0.toEntity() }
    }
}

