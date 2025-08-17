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
    enum SearchScreen: Hashable { case search, bakeryDetail(id: Int) }
    enum FavoritesScreen: Hashable { case favorites, bakeryDetail(id: Int) }
    enum MyScreen: Hashable { case my, settings }
    
    @Published var selectedTab: Tab = .home
    @Published var isTabBarHidden = false
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var myPath = NavigationPath()
    
    let dependency: AppDependency
    init(dependency: AppDependency) { self.dependency = dependency }
    
    // 이동 API
    func switchTab(_ tab: Tab) { selectedTab = tab }
    
    func push(_ screen: HomeScreen) {
        isTabBarHidden = true
        homePath.append(screen) 
    }
    func push(_ screen: SearchScreen)    { searchPath.append(screen) }
    func push(_ screen: FavoritesScreen) { favoritesPath.append(screen) }
    func push(_ screen: MyScreen)        { myPath.append(screen) }
    
    func popHome() { 
        if !homePath.isEmpty { 
            homePath.removeLast() 
            // homePath가 비어있으면 홈 화면이므로 탭바 표시, 아니면 리스트 화면이므로 탭바 숨김
            isTabBarHidden = !homePath.isEmpty
        } 
    }
    
    // 탭 교차 이동(예: 홈에서 검색 상세로 직행)
    func goToSearchDetail(id: Int) {
        selectedTab = .search
        searchPath = NavigationPath()
        searchPath.append(SearchScreen.bakeryDetail(id: id))
    }
}
