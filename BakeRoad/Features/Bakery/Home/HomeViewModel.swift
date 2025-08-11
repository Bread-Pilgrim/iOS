//
//  HomeViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedAreaCodes: Set<Int> = [14]
    @Published var selectedCategoryCodes: Set<String> = ["A01"]
    @Published var allAreas: [Area] = []
    @Published var preferenceBakeries: [RecommendBakery] = []
    @Published var hotBakeries: [RecommendBakery] = []
    @Published var tourInfoList: [TourInfo] = []
    
    private let getAreaListUseCase: GetAreaListUseCase
    private let getBakeriesUseCase: GetBakeriesUseCase
    private let getTourListUseCase: GetTourListUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private var areaCodes: String { selectedAreaCodes.map(String.init).joined(separator: ",") }
    private var tourCatCodes: String { selectedCategoryCodes.joined(separator: ",") }
    
    init(
        getAreaListUseCase: GetAreaListUseCase,
        getBakeriesUseCase: GetBakeriesUseCase,
        getTourListUseCase: GetTourListUseCase
    ) {
        self.getAreaListUseCase = getAreaListUseCase
        self.getBakeriesUseCase = getBakeriesUseCase
        self.getTourListUseCase = getTourListUseCase
        
        Task { await loadInitial() }
        
        setupBindings()
    }
    
    private func setupBindings() {
        $selectedAreaCodes
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    async let pref = self.getBakeries(.preference)
                    async let hot  = self.getBakeries(.hot)
                    async let tour = self.getTourList()
                    self.preferenceBakeries = await pref
                    self.hotBakeries = await hot
                    self.tourInfoList = await tour
                }
            }
            .store(in: &cancellables)
        
        $selectedCategoryCodes
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task { self.tourInfoList = await self.getTourList() }
            }
            .store(in: &cancellables)
    }
    
    private func loadInitial() async {
        async let areas = getAreaList()
        async let pref  = getBakeries(.preference)
        async let hot   = getBakeries(.hot)
        async let tours = getTourList()
        allAreas = await areas
        preferenceBakeries = await pref
        hotBakeries = await hot
        tourInfoList = await tours
    }
    
    func getAreaList() async -> [Area] {
        (try? await getAreaListUseCase.execute()) ?? []
    }
    func getBakeries(_ type: RecommendBakeryType) async -> [RecommendBakery] {
        let result = (try? await getBakeriesUseCase.execute(type, areaCode: areaCodes)) ?? []
        return Array(result.prefix(20))
    }
    func getTourList() async -> [TourInfo] {
        let result = (try? await getTourListUseCase.execute(areaCodes: areaCodes, tourCatCodes: tourCatCodes)) ?? []
        return Array(result.prefix(5))
    }
    
    func toggleArea(_ id: Int) {
        if id == 14 {
            selectedAreaCodes = [14]
        } else {
            if selectedAreaCodes.contains(id) {
                if selectedAreaCodes.count > 1 { selectedAreaCodes.remove(id) }
            } else {
                selectedAreaCodes.insert(id)
            }
            selectedAreaCodes.remove(14)
        }
    }
    func toggleCategory(_ id: String) {
        if selectedCategoryCodes.contains(id) {
            if selectedCategoryCodes.count > 1 { selectedCategoryCodes.remove(id) }
        } else {
            selectedCategoryCodes.insert(id)
        }
    }
}
