//
//  OnboardingViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

enum OnboardingStep: Int, CaseIterable {
    case breadType = 1
    case flavor = 2
    case atmosphere = 3
    
    var titleText: String {
        switch self {
        case .breadType: return "빵 취향을 알려주세요!"
        case .flavor: return "어떤 빵 맛을 선호하세요?"
        case .atmosphere: return "어떤 종류의 빵집을 선호하시나요?"
        }
    }
    
    var subtitleText: String {
        switch self {
        case .breadType, .flavor, .atmosphere:
            return "(복수 선택 가능🥐)"
        }
    }
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .breadType
    @Published var selections: [OnboardingStep: [Preference]] = [:]
    @Published var allOptions: [OnboardingStep: [Preference]] = [:]
    private var originalSelections: [OnboardingStep: [Preference]] = [:]
    
    let isPreferenceEdit: Bool
    var canProceed: Bool {
        !(selections[currentStep]?.isEmpty ?? true)
    }
    var canGoBack: Bool {
        originalSelections == selections
    }
    
    var onNavigateBack: (() -> Void)?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase
    private let userOnboardUseCase: UserOnboardUseCase
    private let getUserPreferenceUseCase: GetUserPreferenceUseCase
    private let updateUserPreferenceUseCase: UpdateUserPreferenceUseCase
    
    init(
        getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase,
        userOnboardUseCase: UserOnboardUseCase,
        getUserPreferenceUseCase: GetUserPreferenceUseCase,
        updateUserPreferenceUseCase: UpdateUserPreferenceUseCase,
        isPreferenceEdit: Bool = false
    ) {
        self.getPreferenceOptionsUseCase = getPreferenceOptionsUseCase
        self.userOnboardUseCase = userOnboardUseCase
        self.getUserPreferenceUseCase = getUserPreferenceUseCase
        self.updateUserPreferenceUseCase = updateUserPreferenceUseCase
        self.isPreferenceEdit = isPreferenceEdit
        
        Task {
            await fetchPreferences()
            if isPreferenceEdit {
                await fetchUserPreferences()
            }
        }
    }
    
    private func fetchPreferences() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            allOptions = try await getPreferenceOptionsUseCase.execute()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    private func fetchUserPreferences() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userPrefs = try await getUserPreferenceUseCase.execute()
            selections = userPrefs
            originalSelections = userPrefs
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    func submitOnboarding(_ nickName: String) async -> [Badge]? {
        guard !isLoading else { return nil }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await userOnboardUseCase.execute(.init(
                nickname: nickName,
                bread_types: selections[.breadType]?.map(\.id) ?? [],
                flavors: selections[.flavor]?.map(\.id) ?? [],
                atmospheres: selections[.atmosphere]?.map(\.id) ?? []
            ))
            
            return response
        } catch let APIError.serverError(_, message) {
            errorMessage = message
            return nil
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
            return nil
        }
    }
    
    func updatePreferences() async -> Bool {
        guard !isLoading else { return false }
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 현재 선택된 것들의 ID 배열
            let currentIds = getAllSelectedIds(from: selections)
            // 원래 선택되어 있던 것들의 ID 배열
            let originalIds = getAllSelectedIds(from: originalSelections)
            
            // 새로 추가된 것들 (현재에는 있지만 원래에는 없던 것들)
            let addedIds = Set(currentIds).subtracting(Set(originalIds))
            // 삭제된 것들 (원래에는 있었지만 현재에는 없는 것들)
            let deletedIds = Set(originalIds).subtracting(Set(currentIds))
            
            let request = UpdateUserPreferenceRequestDTO(
                add: Array(addedIds),
                delete: Array(deletedIds)
            )
            try await updateUserPreferenceUseCase.execute(request)
            return true
        } catch let APIError.serverError(_, message) {
            errorMessage = message
            return false
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
            return false
        }
    }
    
    private func getAllSelectedIds(from selections: [OnboardingStep: [Preference]]) -> [Int] {
        var allIds: [Int] = []
        for step in OnboardingStep.allCases {
            if let preferences = selections[step] {
                allIds.append(contentsOf: preferences.map(\.id))
            }
        }
        return allIds
    }
    
    func navigateBack() {
        onNavigateBack?()
    }
}
