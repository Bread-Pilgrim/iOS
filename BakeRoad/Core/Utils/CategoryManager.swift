//
//  CategoryManager.swift
//  BakeRoad
//
//  Created by 이현호 on 8/24/25.
//

import Foundation

final class CategoryManager: ObservableObject {
    static let shared = CategoryManager()
    
    @Published var selectedCategoryCodes: Set<String> = ["A01"]
    
    private init() {}
    
    func toggleCategory(_ id: String) {
        if selectedCategoryCodes.contains(id) {
            if selectedCategoryCodes.count > 1 {
                selectedCategoryCodes.remove(id)
            }
        } else {
            selectedCategoryCodes.insert(id)
        }
    }
    
    var tourCatCodes: String {
        selectedCategoryCodes.joined(separator: ",")
    }
}