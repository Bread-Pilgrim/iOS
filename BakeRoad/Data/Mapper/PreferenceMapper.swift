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
            .atmosphere: response.atmosphere.map { map(from: $0) }
        ]
    }
    
    static func map(from dto: UserPreferenceTypeDTO) -> Preference {
        Preference(id: dto.preference_id, name: dto.preference_name)
    }
    
    static func map(from response: GetUserPreferencesResponseDTO) -> [OnboardingStep: [Preference]] {
        return [
            .breadType: response.breadTypes.map { map(from: $0) },
            .flavor: response.flavors.map { map(from: $0) },
            .atmosphere: response.atmospheres.map { map(from: $0) }
        ]
    }
}
