//
//  MainView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/11/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @StateObject private var tabViewModels = TabViewModels()
    
    var body: some View {
        ZStack {
            Group {
                switch coordinator.selectedTab {
                case .home:      homeTab
                case .search:    searchTab
                case .favorites: favoritesTab
                case .my:        myTab
                }
            }
            .padding(.bottom, coordinator.isTabBarHidden ? 0 : 72)
        }
        .overlay(alignment: .bottom) {
            if !coordinator.isTabBarHidden {
                CustomTabBar(
                    selected: coordinator.selectedTab,
                    onSelect: { coordinator.selectedTab = $0 }
                )
                .ignoresSafeArea(edges: .bottom)
                .opacity(coordinator.isKeyboardVisible ? 0 : 1)
            }
        }
        .onAppear {
            setupViewModels()
        }
    }
}

class TabViewModels: ObservableObject {
    @Published var homeViewModel: HomeViewModel?
}

// MARK: - ViewModel Setup
extension MainView {
    private func setupViewModels() {
        if tabViewModels.homeViewModel == nil {
            tabViewModels.homeViewModel = createHomeViewModel()
        }
    }
    
    private func createHomeViewModel() -> HomeViewModel {
        let viewModel = HomeViewModel(
            getAreaListUseCase: coordinator.dependency.getAreaListUseCase,
            getBakeriesUseCase: coordinator.dependency.getBakeriesUseCase,
            getTourListUseCase: coordinator.dependency.getTourListUseCase,
            getPreferenceOptionsUseCase: coordinator.dependency.getPreferenceOptionsUseCase,
            userOnboardUseCase: coordinator.dependency.userOnboardUseCase,
            getUserPreferenceUseCase: coordinator.dependency.getUserPreferenceUseCase,
            updateUserPreferenceUseCase: coordinator.dependency.updateUserPreferenceUseCase,
            getTourEventUseCase: coordinator.dependency.getTourEventUseCase
        )
        
        viewModel.onNavigateToBakeryList = { filter in
            coordinator.push(.list(filter))
        }
        viewModel.onNavigateToBakeryDetail = { filter in
            coordinator.push(.bakeryDetail(filter))
        }
        
        return viewModel
    }
    
    // MARK: - Tab Views
    private var homeTab: some View {
        NavigationStack(path: $coordinator.homePath) {
            if let homeViewModel = tabViewModels.homeViewModel {
                HomeView(viewModel: homeViewModel)
                    .navigationDestination(for: MainCoordinator.HomeScreen.self) { screen in
                        homeNavigationDestination(screen)
                    }
            }
        }
    }
    
    private var searchTab: some View {
        NavigationStack(path: $coordinator.searchPath) {
            SearchView(viewModel: createSearchViewModel())
                .navigationDestination(for: MainCoordinator.SearchScreen.self) { screen in
                    searchNavigationDestination(screen)
                }
        }
    }
    
    private var favoritesTab: some View {
        NavigationStack(path: $coordinator.favoritesPath) {
            MyBakeryView(viewModel: createFavoritesViewModel())
                .navigationDestination(for: MainCoordinator.FavoritesScreen.self) { screen in
                    favoritesNavigationDestination(screen)
                }
        }
    }
    
    private var myTab: some View {
        NavigationStack(path: $coordinator.myPath) {
            UserInfoView(viewModel: createUserInfoViewModel())
                .navigationDestination(for: MainCoordinator.MyScreen.self) { screen in
                    myNavigationDestination(screen)
                }
        }
    }
}

// MARK: - Navigation Destinations
extension MainView {
    @ViewBuilder
    private func homeNavigationDestination(_ screen: MainCoordinator.HomeScreen) -> some View {
        switch screen {
        case .list(let filter):
            BakeryListView(viewModel: createBakeryListViewModel(filter: filter))
        case .bakeryDetail(let filter):
            BakeryDetailView(viewModel: createBakeryDetailViewModel(filter: filter, popAction: coordinator.popHome, popToHome: coordinator.returnToHome))
                .hideNavigationBar()
        }
    }
    
    @ViewBuilder
    private func searchNavigationDestination(_ screen: MainCoordinator.SearchScreen) -> some View {
        switch screen {
        case .searchDetail(let filter):
            BakeryDetailView(viewModel: createBakeryDetailViewModel(filter: filter, popAction: coordinator.popSearch, popToHome: coordinator.returnToHome))
                .hideNavigationBar()
        }
    }
    
    @ViewBuilder
    private func favoritesNavigationDestination(_ screen: MainCoordinator.FavoritesScreen) -> some View {
        switch screen {
        case .favoritesDetail(let filter):
            BakeryDetailView(viewModel: createBakeryDetailViewModel(filter: filter, popAction: coordinator.popFavorites, popToHome: coordinator.returnToHome))
                .hideNavigationBar()
        }
    }
    
    @ViewBuilder
    private func myNavigationDestination(_ screen: MainCoordinator.MyScreen) -> some View {
        switch screen {
        case .breadReport(let year, let month):
            BreadReportView(viewModel: createBreadReportViewModel(year: year, month: month))
                .hideNavigationBar()
        case .breadReportList:
            BreadReportListView(viewModel: createBreadReportListViewModel())
                .hideNavigationBar()
        case .badge:
            BadgeListView(viewModel: createBadgeListViewModel())
                .hideNavigationBar()
        case .myReview:
            UserReviewListView(viewModel: createUserReviewListViewModel())
                .hideNavigationBar()
        case .myReviewDetail(let filter):
            BakeryDetailView(viewModel: createBakeryDetailViewModel(filter: filter, popAction: coordinator.returnToHome, popToHome: coordinator.returnToHome))
                .hideNavigationBar()
        case .preference:
            OnboardingView(viewModel: createPreferenceViewModel()) {
                coordinator.popMy()
                ToastManager.show(message: "내 빵 취향이 변경되었습니다!")
            }
            .hideNavigationBar()
        case .setting:
            SettingView(viewModel: createSettingViewModel())
                .hideNavigationBar()
        case .notification:
            NotificationView(viewModel: createNotificationViewModel())
                .hideNavigationBar()
        case .appInfo:
            AppInfoView { coordinator.popMy() }
                .hideNavigationBar()
        }
    }
}

// MARK: - ViewModel Factory Methods
extension MainView {
    private func createSearchViewModel() -> SearchViewModel {
        let viewModel = SearchViewModel(
            searchBakeryUseCase: coordinator.dependency.searchBakeyUseCase,
            recentBakeryUseCase: coordinator.dependency.recentBakeryUseCase,
            deleteRecentBakeryUseCase: coordinator.dependency.deleteRecentBakeryUseCase
        )
        viewModel.onNavigateToBakeryDetail = { filter in
            coordinator.push(.searchDetail(filter))
        }
        return viewModel
    }
    
    private func createFavoritesViewModel() -> MyBakeryViewModel {
        let viewModel = MyBakeryViewModel(
            getMyBakeryListUseCase: coordinator.dependency.getMyBakeryListUseCase
        )
        viewModel.onNavigateToBakeryDetail = { filter in
            coordinator.push(.favoritesDetail(filter))
        }
        return viewModel
    }
    
    private func createBakeryListViewModel(filter: BakeryListFilter) -> BakeryListViewModel {
        let viewModel = BakeryListViewModel(
            filter: filter,
            getBakeryListUseCase: coordinator.dependency.getBakeryListUseCase
        )
        viewModel.onNavigateToBakeryDetail = { bakery in
            coordinator.push(.bakeryDetail(
                BakeryDetailFilter(
                    bakeryId: bakery.id,
                    areaCodes: filter.areaCodes,
                    tourCatCodes: filter.tourCatCodes
                )
            ))
        }
        viewModel.onNavigateBack = {
            coordinator.popHome()
        }
        return viewModel
    }
    
    private func createBakeryDetailViewModel(
        filter: BakeryDetailFilter,
        popAction: @escaping () -> Void,
        popToHome: @escaping () -> Void
    ) -> BakeryDetailViewModel {
        let viewModel = BakeryDetailViewModel(
            filter: filter,
            getBakeryDetailUseCase: coordinator.dependency.getBakeryDetailUseCase,
            getTourListUseCase: coordinator.dependency.getTourListUseCase,
            getBakeryReviewsUseCase: coordinator.dependency.getBakeryReviewsUseCase,
            getBakeryMyReviewsUseCase: coordinator.dependency.getBakeryMyReviewsUseCase,
            bakeryLikeUseCase: coordinator.dependency.bakeryLikeUseCase,
            bakeryDislikeUseCase: coordinator.dependency.bakeryDislikeUseCase,
            reviewLikeUseCase: coordinator.dependency.reviewlikeUseCase,
            reviewDislikeUseCase: coordinator.dependency.reviewDislikeUseCase,
            getBakeryReviewEligibilityUseCase: coordinator.dependency.getBakeryReviewEligibilityUseCase,
            getBakeryMenuUseCase: coordinator.dependency.getBakeryMenuUseCase,
            writeReviewUseCase: coordinator.dependency.writeReviewUseCase
        )
        viewModel.onNavigateBack = popAction
        viewModel.onNavigateHome = popToHome
        return viewModel
    }
    
    private func createUserInfoViewModel() -> UserInfoViewModel {
        let viewModel = UserInfoViewModel(
            userProfileUseCase: coordinator.dependency.userProfileUseCase
        )
        viewModel.onNavigateToSettings = {
            coordinator.push(.setting)
        }
        viewModel.onNavigateToPreferenceChange = {
            coordinator.push(.preference)
        }
        viewModel.onNavigateToBreadReport = {
            coordinator.push(.breadReportList)
        }
        viewModel.onNavigateToReceivedBadges = {
            coordinator.push(.badge)
        }
        viewModel.onNavigateToReviews = {
            coordinator.push(.myReview)
        }
        return viewModel
    }
    
    private func createBreadReportViewModel(year: Int, month: Int) -> BreadReportViewModel {
        let viewModel = BreadReportViewModel(
            request: BreadReportRequestDTO(year: year, month: month),
            getBreadReportUseCase: coordinator.dependency.getBreadReportUseCase
        )
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        return viewModel
    }
    
    private func createBreadReportListViewModel() -> BreadReportListViewModel {
        let viewModel = BreadReportListViewModel(
            getBreadReportListUseCase: coordinator.dependency.getBreadReportListUseCase
        )
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        viewModel.onNavigateToReport = { item in
            coordinator.push(.breadReport(year: item.year, month: item.month))
        }
        return viewModel
    }
    
    private func createBadgeListViewModel() -> BadgeListViewModel {
        let viewModel = BadgeListViewModel(
            getBadgeListUseCase: coordinator.dependency.getBadgeListUseCase,
            badgeRepresentUseCase: coordinator.dependency.badgeRepresentUseCase,
            badgeDerepresentUseCase: coordinator.dependency.badgeDerepresentUseCase
        )
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        return viewModel
    }
    
    private func createUserReviewListViewModel() -> UserReviewListViewModel {
        let viewModel = UserReviewListViewModel(
            userReviewUseCase: coordinator.dependency.userReviewUseCase,
            reviewLikeUseCase: coordinator.dependency.reviewlikeUseCase,
            reviewDislikeUseCase: coordinator.dependency.reviewDislikeUseCase
        )
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        viewModel.onNavigateToDetail = { filter in
            coordinator.push(.myReviewDetail(filter))
        }
        return viewModel
    }
    
    private func createPreferenceViewModel() -> OnboardingViewModel {
        let viewModel = OnboardingViewModel(
            getPreferenceOptionsUseCase: coordinator.dependency.getPreferenceOptionsUseCase,
            userOnboardUseCase: coordinator.dependency.userOnboardUseCase,
            getUserPreferenceUseCase: coordinator.dependency.getUserPreferenceUseCase,
            updateUserPreferenceUseCase: coordinator.dependency.updateUserPreferenceUseCase,
            isPreferenceEdit: true
        )
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        return viewModel
    }
    
    private func createSettingViewModel() -> SettingViewModel {
        let viewModel = SettingViewModel()
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        viewModel.onNavigateToNotifications = {
            coordinator.push(.notification)
        }
        viewModel.onNavigateToAppInfo = {
            coordinator.push(.appInfo)
        }
        viewModel.onLogout = {
            coordinator.logout()
        }
        viewModel.onDeleteAccount = {
            coordinator.deleteAccount()
        }
        return viewModel
    }
    
    private func createNotificationViewModel() -> NotificationViewModel {
        let viewModel = NotificationViewModel(
            getNoticeUseCase: coordinator.dependency.getNoticeUseCase
        )
        viewModel.onNavigateBack = {
            coordinator.popMy()
        }
        return viewModel
    }
}

struct CustomTabBar: View {
    let selected: MainCoordinator.Tab
    let onSelect: (MainCoordinator.Tab) -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedCorners(radius: 40, corners: [.topLeft, .topRight])
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 40, y: -4)
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    tab(.home,      "홈",     "home_fill",    "home")
                    tab(.search,    "검색",     "search_fill",  "search")
                    tab(.favorites, "내 빵집",  "favorites_fill",   "favorites")
                    tab(.my,        "나의 빵글", "my_fill",  "my")
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 19)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
    }
    
    private func tab(_ tab: MainCoordinator.Tab,
                     _ title: String,
                     _ sel: String,
                     _ nor: String) -> some View {
        let isSel = (selected == tab)
        return Button {
            onSelect(tab)
        } label: {
            VStack(spacing: 2) {
                Image(isSel ? sel : nor)
                Text(title)
                    .font(.body3xsmallMedium)
                    .foregroundColor(isSel ? .primary500 : .gray300)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
