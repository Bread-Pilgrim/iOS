//
//  DetailMenuSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailMenuSection: View {
    let menus: [BakeryDetail.BakeryMenu]
    @Binding var selectedTab: DetailTab
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추천 메뉴")
                .font(.bodyLargeSemibold)
                .foregroundColor(.gray990)
                .padding(.horizontal, 16)
                .padding(.top, 20)
            
            ForEach(displayedMenus.indices, id: \.self) { index in
                RecommendMenuCard(menu: displayedMenus[index])
                if index < displayedMenus.count - 1 {
                    Divider()
                        .background(Color.gray50)
                        .padding(.horizontal, 16)
                }
            }
            
            if selectedTab == .home {
                BakeRoadOutlinedButton(
                    title: "메뉴 전체보기",
                    style: .assistive,
                    size: .medium
                ) {
                    selectedTab = .menu
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 20)
        .id(DetailTab.menu)
        
        Rectangle()
            .frame(height: 8)
            .foregroundColor(.gray50)
            .padding(.bottom, 20)
    }
    
    private var displayedMenus: [BakeryDetail.BakeryMenu] {
        selectedTab == .home ? Array(menus.prefix(4)) : menus
    }
}
