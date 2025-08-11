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
        }
        .overlay(alignment: .bottom) {
            CustomTabBar(
                selected: coordinator.selectedTab,
                onSelect: { coordinator.selectedTab = $0 }
            )
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private var homeTab: some View {
        NavigationStack(path: $coordinator.homePath) {
            HomeView(viewModel: HomeViewModel(
                getAreaListUseCase: coordinator.dependency.getAreaListUseCase,
                getBakeriesUseCase: coordinator.dependency.getBakeriesUseCase,
                getTourListUseCase: coordinator.dependency.getTourListUseCase
                //                onSelectBakery: { id in coordinator.push(.bakeryDetail(id: id)) }
            ))
            .navigationDestination(for: MainCoordinator.HomeScreen.self) { screen in
                switch screen {
                case .list:
                    EmptyView()
                    //                    HomeView(viewModel: /* 필요 시 루트 재생성 */ HomeViewModel(
                    //                        getAreaListUseCase: coordinator.dependency.getAreaListUseCase,
                    //                        getBakeriesUseCase: coordinator.dependency.getBakeriesUseCase,
                    //                        getTourListUseCase: coordinator.dependency.getTourListUseCase,
                    //                        onSelectBakery: { id in coordinator.push(.bakeryDetail(id: id)) }
                    //                    ))
                case .bakeryDetail(_):
                    EmptyView()
                    //                    BakeryDetailView(
                    //                        viewModel: BakeryDetailViewModel(
                    //                            bakeryID: id,
                    //                            getBakeryDetailUseCase: coordinator.dependency.getBakeriesUseCase
                    //                        )
                    //                    )
                }
            }
        }
    }
    
    private var searchTab: some View {
        NavigationStack(path: $coordinator.searchPath) {
            EmptyView()
                .navigationDestination(for: MainCoordinator.SearchScreen.self) { screen in
                    switch screen {
                    case .search:
                        EmptyView()
                    case .bakeryDetail(_):
                        EmptyView()
                    }
                }
        }
    }
    
    private var favoritesTab: some View {
        NavigationStack(path: $coordinator.favoritesPath) {
            EmptyView()
                .navigationDestination(for: MainCoordinator.FavoritesScreen.self) { screen in
                    switch screen {
                    case .favorites:
                        EmptyView()
                    case .bakeryDetail(_):
                        EmptyView()
                    }
                }
        }
    }
    
    private var myTab: some View {
        NavigationStack(path: $coordinator.myPath) {
            EmptyView()
                .navigationDestination(for: MainCoordinator.MyScreen.self) { screen in
                    switch screen {
                    case .my:
                        EmptyView()
                    case .settings:
                        EmptyView()
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
