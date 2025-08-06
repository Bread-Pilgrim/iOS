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
    @Published var allAreas: [Area] = []
    @Published var preferenceBakeries: [RecommendBakery] = []
    @Published var hotBakeries: [RecommendBakery] = []
    
    private let getAreaListUseCase: GetAreaListUseCase
    private let getBakeriesUseCase: GetBakeriesUseCase
    
    private var areaCodes: String {
        selectedAreaCodes
            .map { String($0) }
            .joined(separator: ", ")
    }
    
    init(
        getAreaListUseCase: GetAreaListUseCase,
        getBakeriesUseCase: GetBakeriesUseCase
    ) {
        self.getAreaListUseCase = getAreaListUseCase
        self.getBakeriesUseCase = getBakeriesUseCase
        
        Task {
            allAreas = await getAreaList()
            preferenceBakeries = await getBakeries(.preference)
            hotBakeries = await getBakeries(.hot)
        }
    }
    
    func getAreaList() async -> [Area] {
        do {
            return try await getAreaListUseCase.execute()
        } catch {
            return []
        }
    }
    
    func getBakeries(_ type: RecommendBakeryType) async -> [RecommendBakery] {
        do {
            return try await getBakeriesUseCase.execute(type, areaCode: areaCodes)
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
