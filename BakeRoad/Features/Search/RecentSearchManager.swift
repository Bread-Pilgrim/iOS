//
//  RecentSearchManager.swift
//  BakeRoad
//
//  Created by 이현호 on 8/21/25.
//

import Foundation

struct RecentSearch: Codable, Identifiable {
    var id = UUID()
    let text: String
    let timestamp: Date
}

final class RecentSearchManager {
    private let userDefaults = UserDefaults.standard
    private let recentSearchKey = "recent_searches"
    private let maxRecentSearches = 10
    
    func getRecentSearches() -> [RecentSearch] {
        guard let data = userDefaults.data(forKey: recentSearchKey),
              let searches = try? JSONDecoder().decode([RecentSearch].self, from: data) else {
            return []
        }
        return searches.sorted { $0.timestamp > $1.timestamp }
    }
    
    func addRecentSearch(_ searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        var recentSearches = getRecentSearches()
        
        // 중복 제거 코드 삭제 - 중복 허용
        let newSearch = RecentSearch(text: trimmedText, timestamp: Date())
        
        // 맨 앞에 추가
        recentSearches.insert(newSearch, at: 0)
        
        // 최대 개수 제한
        if recentSearches.count > maxRecentSearches {
            recentSearches = Array(recentSearches.prefix(maxRecentSearches))
        }
        
        saveRecentSearches(recentSearches)
    }
    
    func removeRecentSearch(_ searchId: UUID) {
        var recentSearches = getRecentSearches()
        recentSearches.removeAll { $0.id == searchId }
        saveRecentSearches(recentSearches)
    }
    
    func clearAllRecentSearches() {
        userDefaults.removeObject(forKey: recentSearchKey)
    }
    
    private func saveRecentSearches(_ searches: [RecentSearch]) {
        if let data = try? JSONEncoder().encode(searches) {
            userDefaults.set(data, forKey: recentSearchKey)
        }
    }
}
