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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let logoutUseCase: LogoutUseCase
    private let deleteAccountUseCase: DeleteAccountUseCase
    
    init(
        logoutUseCase: LogoutUseCase,
        deleteAccountUseCase: DeleteAccountUseCase
    ) {
        self.logoutUseCase = logoutUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
    }
    
    var onNavigateBack: (() -> Void)?
    var onNavigateToNotifications: (() -> Void)?
    var onNavigateToAppInfo: (() -> Void)?
    var onLogout: (() -> Void)?
    var onDeleteAccount: (() -> Void)?
    
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
        Task {
            await deleteAccount()
            clearAllUserDefaults()
            showingDeleteAccountAlert = false
            showingDeleteCompletionAlert = true
        }
    }
    
    func handleDeleteCompletion() {
        showingDeleteCompletionAlert = false
        onDeleteAccount?()
    }
    
    func dismissAlert() {
        showingLogoutAlert = false
        showingDeleteAccountAlert = false
        showingDeleteCompletionAlert = false
    }
    
    func logout() {
        Task {
            await logoutAccount()
            clearAllUserDefaults()
            showingLogoutAlert = false
            onLogout?()
        }
    }
    
    private func deleteAccount() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await deleteAccountUseCase.execute()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    private func logoutAccount() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await logoutUseCase.execute()
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
    }
    
    private func clearAllUserDefaults() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleId)
        UserDefaults.standard.synchronize()
    }
}
