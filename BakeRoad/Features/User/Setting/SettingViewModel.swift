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
    @Published var showingDeleteAccountAlert = false
    @Published var showingDeleteCompletionAlert = false
    
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
    
    func showDeleteAccountAlert() {
        showingDeleteAccountAlert = true
    }
    
    func confirmDeleteAccount() {
        showingDeleteAccountAlert = false
        
        Task {
            await deleteAccount()
            showingDeleteCompletionAlert = true
        }
    }
    
    private func deleteAccount() async { }
    
    func handleDeleteCompletion() {
        showingDeleteCompletionAlert = false
        onLogout?()
    }
    
    func dismissAlert() {
        showingLogoutAlert = false
        showingDeleteAccountAlert = false
        showingDeleteCompletionAlert = false
    }
    
    func logout() {
        showingLogoutAlert = false
        onLogout?()
    }
}
