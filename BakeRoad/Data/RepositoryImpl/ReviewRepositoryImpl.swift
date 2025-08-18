//
//  ReviewRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/18/25.
//

import Foundation

final class ReviewRepositoryImpl: ReviewRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func postReviewLike(_ id: Int) async throws {
        let request = APIRequest(
            path: ReviewEndPoint.like(id),
            method: .post
        )
        
        let _ = try await apiClient.request(request, responseType: ReviewLikeResponseDTO.self)
    }
    
    func deleteReviewLike(_ id: Int) async throws {
        let request = APIRequest(
            path: ReviewEndPoint.dislike(id),
            method: .delete
        )
        
        let _ = try await apiClient.request(request, responseType: ReviewLikeResponseDTO.self)
    }
}
