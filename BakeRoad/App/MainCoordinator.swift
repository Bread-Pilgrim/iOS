//
//  MainCoordinator.swift
//  BakeRoad
//
//  Created by 이현호 on 8/11/25.
//

import SwiftUI

@MainActor
final class MainCoordinator: ObservableObject {
    enum Tab: Hashable {
        case home
        case search
        case favorites
        case my
    }
    
    // 탭별 화면 enum
    enum HomeScreen: Hashable { case list(_ filter: BakeryListFilter), bakeryDetail(_ filter: BakeryDetailFilter) }
    enum SearchScreen: Hashable { case searchDetail(_ filter: BakeryDetailFilter) }
    enum FavoritesScreen: Hashable { case favoritesDetail(_ filter: BakeryDetailFilter) }
    enum MyScreen: Hashable { case breadReportList, breadReport(year: Int, month: Int), badge, myReview, myReviewDetail(_ filter: BakeryDetailFilter), preference, setting, notification, appInfo }
    
    @Published var selectedTab: Tab = .home
    @Published var isTabBarHidden = false
    @Published var isKeyboardVisible = false
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var myPath = NavigationPath()
    
    let dependency: AppDependency
    weak var appCoordinator: AppCoordinator?
    
    init(dependency: AppDependency, appCoordinator: AppCoordinator? = nil) {
        self.dependency = dependency
        self.appCoordinator = appCoordinator
        setupKeyboardObservers()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.isKeyboardVisible = true
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.isKeyboardVisible = false
            }
        }
    }
    
    func logout() {
        appCoordinator?.logout()
    }
    
    func deleteAccount() {
        appCoordinator?.deleteAccount()
    }
    
    func switchTab(_ tab: Tab) { selectedTab = tab }
    
    func push(_ screen: HomeScreen) {
        isTabBarHidden = true
        homePath.append(screen)
    }
    func push(_ screen: SearchScreen) {
        isTabBarHidden = true
        searchPath.append(screen)
    }
    func push(_ screen: FavoritesScreen) {
        isTabBarHidden = true
        favoritesPath.append(screen)
    }
    func push(_ screen: MyScreen) {
        isTabBarHidden = true
        myPath.append(screen)
    }
    
    func popHome() {
        if !homePath.isEmpty {
            homePath.removeLast()
            isTabBarHidden = !homePath.isEmpty
        }
    }
    
    func popSearch() {
        if !searchPath.isEmpty {
            searchPath.removeLast()
            isTabBarHidden = !searchPath.isEmpty
        }
    }
    
    func popFavorites() {
        if !favoritesPath.isEmpty {
            favoritesPath.removeLast()
            isTabBarHidden = !favoritesPath.isEmpty
        }
    }
    
    func popMy() {
        if !myPath.isEmpty {
            myPath.removeLast()
            isTabBarHidden = !myPath.isEmpty
        }
    }
    
    func returnToHome() {
        clearAllNavigationStacks()
        selectedTab = .home
        isTabBarHidden = false
    }
    
    private func clearAllNavigationStacks() {
        homePath = NavigationPath()
        searchPath = NavigationPath()
        favoritesPath = NavigationPath()
        myPath = NavigationPath()
    }
}
