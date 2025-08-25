//
//  MainView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/11/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    
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
    }
    
    private var homeTab: some View {
        NavigationStack(path: $coordinator.homePath) {
            HomeView(viewModel: {
                let viewModel = HomeViewModel(
                    getAreaListUseCase: coordinator.dependency.getAreaListUseCase,
                    getBakeriesUseCase: coordinator.dependency.getBakeriesUseCase,
                    getTourListUseCase: coordinator.dependency.getTourListUseCase,
                    getPreferenceOptionsUseCase: coordinator.dependency.getPreferenceOptionsUseCase,
                    userOnboardUseCase: coordinator.dependency.userOnboardUseCase,
                    getUserPreferenceUseCase: coordinator.dependency.getUserPreferenceUseCase,
                    updateUserPreferenceUseCase: coordinator.dependency.updateUserPreferenceUseCase
                )
                viewModel.onNavigateToBakeryList = { filter in
                    coordinator.push(.list(filter))
                }
                viewModel.onNavigateToBakeryDetail = { filter in
                    coordinator.push(.bakeryDetail(filter))
                }
                return viewModel
            }())
            .navigationDestination(for: MainCoordinator.HomeScreen.self) { screen in
                switch screen {
                case .list(let filter):
                    BakeryListView(viewModel: {
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
                    }())
                case .bakeryDetail(let filter):
                    BakeryDetailView(viewModel: {
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
                        viewModel.onNavigateBack = {
                            coordinator.popHome()
                        }
                        return viewModel
                    }())
                    .hideNavigationBar()
                }
            }
        }
    }
    
    private var searchTab: some View {
        NavigationStack(path: $coordinator.searchPath) {
            SearchView(viewModel: {
                let viewModel = SearchViewModel(
                    searchBakeryUseCase: coordinator.dependency.searchBakeyUseCase
                )
                viewModel.onNavigateToBakeryDetail = { filter in
                    coordinator.push(.searchDetail(filter))
                }
                return viewModel
            }())
            .navigationDestination(for: MainCoordinator.SearchScreen.self) { screen in
                switch screen {
                case .searchDetail(let filter):
                    BakeryDetailView(viewModel: {
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
                        viewModel.onNavigateBack = {
                            coordinator.popSearch()
                        }
                        return viewModel
                    }())
                    .hideNavigationBar()
                }
            }
        }
    }
    
    private var favoritesTab: some View {
        NavigationStack(path: $coordinator.favoritesPath) {
            MyBakeryView(viewModel: {
                let viewModel = MyBakeryViewModel(
                    getMyBakeryListUseCase: coordinator.dependency.getMyBakeryListUseCase
                )
                viewModel.onNavigateToBakeryDetail = { filter in
                    coordinator.push(.favoritesDetail(filter))
                }
                return viewModel
            }())
            .navigationDestination(for: MainCoordinator.FavoritesScreen.self) { screen in
                switch screen {
                case .favoritesDetail(let filter):
                    BakeryDetailView(viewModel: {
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
                        viewModel.onNavigateBack = {
                            coordinator.popFavorites()
                        }
                        return viewModel
                    }())
                    .hideNavigationBar()
                }
            }
        }
    }
    
    private var myTab: some View {
        NavigationStack(path: $coordinator.myPath) {
            UserInfoView(viewModel: {
                let viewModel = UserInfoViewModel(
                    userProfileUseCase: coordinator.dependency.userProfileUseCase
                )
                viewModel.onNavigateToSettings = {
                    coordinator.push(.setting)
                }
                viewModel.onNavigateToPreferenceChange = {
                    // 취향 변경 화면으로 이동 (나중에 추가)
                }
                viewModel.onNavigateToBadgeSettings = {
                    // 뱃지 설정 화면으로 이동 (나중에 추가)
                }
                viewModel.onNavigateToEarnings = {
                    // 빵말정산 화면으로 이동 (나중에 추가)
                }
                viewModel.onNavigateToReceivedBreadges = {
                    // 받은 빵지 화면으로 이동 (나중에 추가)
                }
                viewModel.onNavigateToReviews = {
                    // 내가 쓴 리뷰 화면으로 이동 (나중에 추가)
                }
                return viewModel
            }())
            .navigationDestination(for: MainCoordinator.MyScreen.self) { screen in
                switch screen {
                case .my:
                    EmptyView()
                case .setting:
                    SettingView(viewModel: {
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
                            // 로그아웃 처리 로직 (나중에 추가)
                        }
                        return viewModel
                    }())
                    .hideNavigationBar()
                case .notification:
                    NotificationView(viewModel: {
                        let viewModel = NotificationViewModel()
                        viewModel.onNavigateBack = {
                            coordinator.popMy()
                        }
                        return viewModel
                    }())
                    .hideNavigationBar()
                case .appInfo:
                    AppInfoView {
                        coordinator.popMy()
                    }
                    .hideNavigationBar()
                }
            }
        }
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
