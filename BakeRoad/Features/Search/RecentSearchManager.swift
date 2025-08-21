//
//  RecentSearchManager.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

final class RecentSearchManager {
    private let userDefaults = UserDefaults.standard
    private let recentSearchKey = "recent_searches"
    private let maxRecentSearches = 10
    
    func getRecentSearches() -> [String] {
        return userDefaults.stringArray(forKey: recentSearchKey) ?? []
    }
    
    func addRecentSearch(_ searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        var recentSearches = getRecentSearches()
        
        // 중복 제거
        recentSearches.removeAll { $0 == trimmedText }
        
        // 맨 앞에 추가
        recentSearches.insert(trimmedText, at: 0)
        
        // 최대 개수 제한
        if recentSearches.count > maxRecentSearches {
            recentSearches = Array(recentSearches.prefix(maxRecentSearches))
        }
        
        userDefaults.set(recentSearches, forKey: recentSearchKey)
    }
    
    func removeRecentSearch(_ searchText: String) {
        var recentSearches = getRecentSearches()
        recentSearches.removeAll { $0 == searchText }
        userDefaults.set(recentSearches, forKey: recentSearchKey)
    }
    
    func clearAllRecentSearches() {
        userDefaults.removeObject(forKey: recentSearchKey)
    }
}