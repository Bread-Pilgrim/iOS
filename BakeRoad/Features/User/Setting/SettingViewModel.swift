//
//  SettingViewModel.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import Foundation

@MainActor
class SettingViewModel: ObservableObject {
    @Published var showingLogoutAlert = false
    
    var onNavigateBack: (() -> Void)?
    var onNavigateToNotifications: (() -> Void)?
    var onNavigateToAppInfo: (() -> Void)?
    var onLogout: (() -> Void)?
    
    func navigateBack() {
        onNavigateBack?()
    }
    
    func navigateToNotifications() {
        onNavigateToNotifications?()
    }
    
    func navigateToAppInfo() {
        onNavigateToAppInfo?()
    }
    
    func showLogoutAlert() {
        showingLogoutAlert = true
    }
    
    func dismissAlert() {
        showingLogoutAlert = false
    }
    
    func logout() {
        showingLogoutAlert = false
        onLogout?()
    }
}
