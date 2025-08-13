//
//  BakeryDetailViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

//@MainActor
//final class BakeryDetailViewModel: ObservableObject {
//    @Published var bakeryDetail: BakeryDetail
//    @Published var errorMessage: String?
//
//    init(
//        id: Int,
//        getBakeryListUseCase: GetBakeryListUseCase
//    ) {
//        self.fetcher = PageFetcher<Bakery>(pageSize: 15) { page, size in
//            let request = BakeryListRequestDTO(
//                area_code: filter.areaCodes.map(String.init).joined(separator: ","),
//                page_no: page,
//                page_size: size
//            )
//            return try await getBakeryListUseCase.execute(filter.type, request: request)
//        }
//
//        Task { await loadInitial() }
//    }
//
//    func loadInitial() async {
//        do {
//            try await fetcher.loadInitial()
//            syncState()
//        } catch let APIError.serverError(_, message) {
//            errorMessage = message
//        } catch {
//            errorMessage = "잠시 후 다시 시도해주세요."
//        }
//    }
//
//    func loadMoreIfNeeded(currentItem: Bakery) async {
//        do {
//            try await fetcher.loadMoreIfNeeded(currentItem: currentItem)
//            syncState()
//        } catch let APIError.serverError(_, message) {
//            errorMessage = message
//        } catch {
//            errorMessage = "잠시 후 다시 시도해주세요."
//        }
//    }
//
//    private func syncState() {
//        bakeries = fetcher.page.items
//        hasNext = fetcher.page.hasNext
//    }
//}
