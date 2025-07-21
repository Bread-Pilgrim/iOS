//
//  PreferenceMapper.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

enum PreferenceMapper {
    static func map(from dto: PreferenceTypeDTO) -> Preference {
        Preference(id: dto.id, name: dto.name)
    }

    static func map(from response: GetPreferencesResponseDTO) -> [OnboardingStep: [Preference]] {
        return [
            .breadType: response.breadType.map { map(from: $0) },
            .flavor: response.flavor.map { map(from: $0) },
            .atmosphere: response.atmosphere.map { map(from: $0) },
            .area: response.cArea.map { map(from: $0) }
        ]
    }
}
