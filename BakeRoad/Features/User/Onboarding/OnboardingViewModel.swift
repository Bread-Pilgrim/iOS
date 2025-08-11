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
    
    var canProceed: Bool {
        !(selections[currentStep]?.isEmpty ?? true)
    }
    
    @Published var errorMessage: String = ""
    
    private let getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase
    private let userOnboardUseCase: UserOnboardUseCase
    
    init(
        getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase,
        userOnboardUseCase: UserOnboardUseCase
    ) {
        self.getPreferenceOptionsUseCase = getPreferenceOptionsUseCase
        self.userOnboardUseCase = userOnboardUseCase
        Task {
            await fetchPreferences()
        }
    }
    
    private func fetchPreferences() async {
        do {
            allOptions = try await getPreferenceOptionsUseCase.execute()
        } catch {
            print("\(error)")
        }
    }
    
    func submitOnboarding(_ nickName: String) async -> Bool {
        do {
            try await userOnboardUseCase.execute(.init(
                nickname: nickName,
                bread_types: selections[.breadType]?.map(\.id) ?? [],
                flavors: selections[.flavor]?.map(\.id) ?? [],
                atmospheres: selections[.atmosphere]?.map(\.id) ?? []
            ))
            errorMessage = ""
            return true
        } catch let APIError.serverError(code, message) {
            errorMessage = message
            return false
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
            return false
        }
    }
}
