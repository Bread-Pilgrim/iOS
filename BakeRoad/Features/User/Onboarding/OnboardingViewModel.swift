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
    case area = 4
    
    var titleText: String {
        switch self {
        case .breadType: return "빵 취향을 알려주세요!"
        case .flavor: return "어떤 빵 맛을 선호하세요?"
        case .atmosphere: return "어떤 종류의 빵집을 선호하시나요?"
        case .area: return "원하시는 지역이 있으신가요?"
        }
    }
    
    var subtitleText: String {
        switch self {
        case .breadType, .flavor, .atmosphere, .area:
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
    
    private let getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase
    
    init(getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase) {
        self.getPreferenceOptionsUseCase = getPreferenceOptionsUseCase
        Task {
            await fetchPreferences()
        }
    }
    
    func fetchPreferences() async {
        do {
            allOptions = try await getPreferenceOptionsUseCase.execute()
            print(allOptions)
        } catch {
            print("\(error)")
        }
    }
}
