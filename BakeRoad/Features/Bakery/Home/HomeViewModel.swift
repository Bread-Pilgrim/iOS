//
//  HomeViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedAreaCodes: Set<Int> = [14]
    @Published var selectedCategoryCodes: Set<String> = ["A01"]
    @Published var preferenceBakeries: [RecommendBakery] = []
    @Published var hotBakeries: [RecommendBakery] = []
    
    let allAreas: [Area] = [
        Area(code: 14, name: "부산 전체"),
        Area(code: 1, name: "서면, 전포 (부산진구)"),
        Area(code: 6, name: "광안리, 민락 (수영구)"),
        Area(code: 5, name: "해운대구"),
        Area(code: 3, name: "남구"),
        Area(code: 2, name: "동래구")
    ]
    
    let allCategories: [TourCategory] = [
        TourCategory(id: "A01", title: "자연"),
        TourCategory(id: "A02", title: "역사"),
        TourCategory(id: "A03", title: "레포츠"),
        TourCategory(id: "A04", title: "쇼핑"),
        TourCategory(id: "C01", title: "추천코스")
    ]
    
    private let getBakeriesUseCase: GetBakeriesUseCase
    
    init(
        selectedAreaCodes: Set<Int>,
        selectedCategoryCodes: Set<String>,
        getBakeriesUseCase: GetBakeriesUseCase
    ) {
        self.selectedAreaCodes = selectedAreaCodes
        self.selectedCategoryCodes = selectedCategoryCodes
        self.getBakeriesUseCase = getBakeriesUseCase
        Task {
            preferenceBakeries = await getBakeries(.preference)
            hotBakeries = await getBakeries(.hot)
        }
    }
    
    private func getBakeries(_ type: RecommendBakeryType) async -> [RecommendBakery] {
        do {
            return try await getBakeriesUseCase.execute(type)
        } catch {
            return []
        }
    }
    
    func toggleArea(_ id: Int) {
        if id == 14 {
            selectedAreaCodes = [14]
        } else {
            if selectedAreaCodes.contains(id) {
                if selectedAreaCodes.count > 1 {
                    selectedAreaCodes.remove(id)
                }
            } else {
                selectedAreaCodes.insert(id)
            }
            selectedAreaCodes.remove(14)
        }
    }
    
    func toggleCategory(_ id: String) {
        if selectedCategoryCodes.contains(id) {
            if selectedCategoryCodes.count > 1 {
                selectedCategoryCodes.remove(id)
            }
        } else {
            selectedCategoryCodes.insert(id)
        }
    }
}
