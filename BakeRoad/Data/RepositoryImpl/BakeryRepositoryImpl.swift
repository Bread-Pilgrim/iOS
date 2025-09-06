//
//  BakeryRepositoryImpl.swift
//  BakeRoad
//
//  Created by 이현호 on 8/6/25.
//

import Foundation

final class BakeryRepositoryImpl: BakeryRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getRecommendBakeries(_ type: BakeryType, areaCode: String) async throws -> [RecommendBakery] {
        let request = APIRequest(
            path: type.recommendEndpoint,
            method: .get,
            parameters: ["area_code": areaCode]
        )
        
        let dto = try await apiClient.request(request, responseType: BakeriesRecommendResponseDTO.self)
        
        let entity = dto.map { $0.toEntity() }
        
        return entity
    }
    
    func getBakeryList(_ type: BakeryType, requestDTO: BakeryListRequestDTO) async throws -> Page<Bakery> {
        let request = APIRequest(
            path: type.listEndPoint,
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryListResponseDTO.self)
        
        let entity = dto.toEntity()
        
        return entity
    }
    
    func getBakeryDetail(_ id: Int) async throws -> BakeryDetail {
        let request = APIRequest(
            path: BakeryEndPoint.detail(id),
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryDetailResponseDTO.self)
        
        let entity = dto.toEntity()
        
        return entity
    }
    
    func getBakeryMenus(_ id: Int) async throws -> [BakeryMenu] {
        let request = APIRequest(
            path: BakeryEndPoint.menus(id),
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryMenusDTO.self)
        
        let entity = dto.map { $0.toEntity() }
        
        return entity
    }
    
    func getBakeryReviews(_ id: Int, requestDTO: BakeryReviewRequestDTO) async throws -> BakeryReviewPage {
        let request = APIRequest(
            path: BakeryEndPoint.reviews(id),
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryReviewResponseDTO.self)
        
        let reviews = dto.reviews.map { $0.toEntity() }
        
        let entity = BakeryReviewPage(
            page: Page(items: reviews,
                       nextCursor: dto.nextCursor),
            data: BakeryReviewData(avgRating: dto.avgRating,
                                   reviewCount: dto.reviewCount)
        )
        
        return entity
    }
    
    func getBakeryMyReviews(_ id: Int, requestDTO: BakeryMyReviewRequestDTO) async throws -> Page<BakeryReview> {
        let request = APIRequest(
            path: BakeryEndPoint.myReview(id),
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryMyReviewResponseDTO.self)
        
        let items = dto.reviews.map { $0.toEntity() }
        
        return Page(items: items, nextCursor: dto.nextCursor)
    }
    
    func postBakeryLike(_ id: Int) async throws {
        let request = APIRequest(
            path: BakeryEndPoint.like(id),
            method: .post
        )
        
        let _ = try await apiClient.request(request, responseType: BakeryLikeResponseDTO.self)
    }
    
    func deleteBakeryLike(_ id: Int) async throws {
        let request = APIRequest(
            path: BakeryEndPoint.dislike(id),
            method: .delete
        )
        
        let _ = try await apiClient.request(request, responseType: BakeryLikeResponseDTO.self)
    }
    
    func getBakeryReviewEligibility(_ id: Int) async throws -> BakeryReviewEligibilityResponseDTO {
        let request = APIRequest(
            path: BakeryEndPoint.canReview(id),
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryReviewEligibilityResponseDTO.self)
        
        return dto
    }
    
    func writeReview(_ id: Int, requestDTO: WriteReviewRequestDTO, imageData: [Data]) async throws -> [Badge]? {
        let request = APIRequest(
            path: BakeryEndPoint.writeReview(id),
            method: .post,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.requestMultipart(request, imageData: imageData, responseType: EmptyDTO.self, extraType: [BadgeTriggerResponseDTO].self)
        
        return dto.extra?.map { $0.toEntity() }
    }
    
    func getMyBakeryList(_ type: MyBakeryType, requestDTO: BakeryMyListRequestDTO) async throws -> Page<Bakery> {
        let request = APIRequest(
            path: type.listEndPoint,
            method: .get,
            parameters: requestDTO
        )
        
        let dto = try await apiClient.request(request, responseType: BakeryListResponseDTO.self)
        
        return dto.toEntity()
    }
    
    func getRecentBakeryList() async throws -> [RecommendBakery] {
        let request = APIRequest(
            path: BakeryEndPoint.listRecent,
            method: .get
        )
        
        let dto = try await apiClient.request(request, responseType: [RecentBakeryResponseDTO].self)
        
        return dto.map { $0.toEntity() }
    }
}
