//
//  PreferRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

protocol PreferRepository {
    func getPreferOptions() async throws -> [OnboardingStep: [Preference]]
}
