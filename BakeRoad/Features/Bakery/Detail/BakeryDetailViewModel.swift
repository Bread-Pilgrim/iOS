//
//  BakeryDetailViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/13/25.
//

import Foundation

@MainActor
final class BakeryDetailViewModel: ObservableObject {
    @Published var bakeryDetail: BakeryDetail
    @Published var errorMessage: String?

    private let getBakeryDetailUseCase: GetBakeryDetailUseCase
    
    init(
        id: Int,
        getBakeryDetailUseCase: GetBakeryDetailUseCase
    ) {
        self.getBakeryDetailUseCase = getBakeryDetailUseCase
        Task { await loadInitial(id) }
    }
    
    private func loadInitial(_ id: Int) async {
        async let detail = getBakeryDetail(id)
        bakeryDetail = await detail
    }
    
    private func getBakeryDetail(_ id: Int) async -> BakeryDetail {
        do {
            return try await getBakeryDetailUseCase.execute(id)
        } catch {
            print(error.localizedDescription)
        }
    }
}
