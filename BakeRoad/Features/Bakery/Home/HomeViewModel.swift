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
    private let categoryManager = CategoryManager.shared
    @Published var allAreas: [Area] = []
    @Published var preferenceBakeries: [RecommendBakery] = []
    @Published var hotBakeries: [RecommendBakery] = []
    @Published var tourInfoList: [TourInfo] = []
    @Published var eventPopup: EventPopup?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showEventPopup = false
    
    private let getAreaListUseCase: GetAreaListUseCase
    private let getBakeriesUseCase: GetBakeriesUseCase
    private let getTourListUseCase: GetTourListUseCase
    private let getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase
    private let userOnboardUseCase: UserOnboardUseCase
    private let getUserPreferenceUseCase: GetUserPreferenceUseCase
    private let updateUserPreferenceUseCase: UpdateUserPreferenceUseCase
    private let getTourEventUseCase: GetTourEventUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var onNavigateToBakeryList: ((BakeryListFilter) -> Void)?
    var onNavigateToBakeryDetail: ((BakeryDetailFilter) -> Void)?
    
    private var areaCodes: String { selectedAreaCodes.map(String.init).joined(separator: ",") }
    private var tourCatCodes: String { categoryManager.tourCatCodes }
    
    init(
        getAreaListUseCase: GetAreaListUseCase,
        getBakeriesUseCase: GetBakeriesUseCase,
        getTourListUseCase: GetTourListUseCase,
        getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase,
        userOnboardUseCase: UserOnboardUseCase,
        getUserPreferenceUseCase: GetUserPreferenceUseCase,
        updateUserPreferenceUseCase: UpdateUserPreferenceUseCase,
        getTourEventUseCase: GetTourEventUseCase
    ) {
        self.getAreaListUseCase = getAreaListUseCase
        self.getBakeriesUseCase = getBakeriesUseCase
        self.getTourListUseCase = getTourListUseCase
        self.getPreferenceOptionsUseCase = getPreferenceOptionsUseCase
        self.userOnboardUseCase = userOnboardUseCase
        self.getUserPreferenceUseCase = getUserPreferenceUseCase
        self.updateUserPreferenceUseCase = updateUserPreferenceUseCase
        self.getTourEventUseCase = getTourEventUseCase
        
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
        
        categoryManager.$selectedCategoryCodes
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task { self.tourInfoList = await self.getTourList() }
            }
            .store(in: &cancellables)
    }
    
    func loadInitial() async {
        isLoading = true
        defer { isLoading = false }
        
        async let areas = getAreaList()
        async let pref  = getBakeries(.preference)
        async let hot   = getBakeries(.hot)
        async let tours = getTourList()
        allAreas = await areas
        preferenceBakeries = await pref
        hotBakeries = await hot
        tourInfoList = await tours
        await getTourEvent()
    }
    
    func getAreaList() async -> [Area] {
        (try? await getAreaListUseCase.execute()) ?? []
    }
    func getBakeries(_ type: BakeryType) async -> [RecommendBakery] {
        let result = (try? await getBakeriesUseCase.execute(type, areaCode: areaCodes)) ?? []
        return Array(result.prefix(20))
    }
    func getTourList() async -> [TourInfo] {
        let result = (try? await getTourListUseCase.execute(areaCodes: areaCodes, tourCatCodes: tourCatCodes)) ?? []
        return Array(result.prefix(5))
    }
    func getTourEvent() async {
        if !canShowToday() {
            return
        }
        
        do {
            eventPopup = try await getTourEventUseCase.execute(areaCodes)
            showEventPopup = eventPopup != nil
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
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
        categoryManager.toggleCategory(id)
    }
    
    func didTapPreferenceViewAll() {
        let filter = BakeryListFilter(
            type: .preference,
            areaCodes: selectedAreaCodes,
            tourCatCodes: categoryManager.selectedCategoryCodes
        )
        onNavigateToBakeryList?(filter)
    }
    
    func didTapHotViewAll() {
        let filter = BakeryListFilter(
            type: .hot,
            areaCodes: selectedAreaCodes,
            tourCatCodes: categoryManager.selectedCategoryCodes
        )
        onNavigateToBakeryList?(filter)
    }
    
    func didTapBakery(_ bakery: RecommendBakery) {
        let filter = BakeryDetailFilter(
            bakeryId: bakery.id,
            areaCodes: selectedAreaCodes,
            tourCatCodes: categoryManager.selectedCategoryCodes
        )
        onNavigateToBakeryDetail?(filter)
    }
    
    func createOnboardingViewModel(isPreferenceEdit: Bool) -> OnboardingViewModel {
        return OnboardingViewModel(
            getPreferenceOptionsUseCase: getPreferenceOptionsUseCase,
            userOnboardUseCase: userOnboardUseCase,
            getUserPreferenceUseCase: getUserPreferenceUseCase,
            updateUserPreferenceUseCase: updateUserPreferenceUseCase,
            isPreferenceEdit: isPreferenceEdit
        )
    }
    
    private func canShowToday() -> Bool {
        guard let todayNotShow = UserDefaults.standard.object(forKey: "todayNotShow") as? Date else {
            return true
        }
        
        if Date() > todayNotShow {
            UserDefaults.standard.removeObject(forKey: "todayNotShow")
            return true
        }
        
        return false
    }
}
