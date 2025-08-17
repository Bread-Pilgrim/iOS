//
//  RecommendMenuCard.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import SwiftUI

struct RecommendMenuCard: View {
    let menu: BakeryDetail.BakeryMenu
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if menu.isSignature {
                    BakeRoadChip(title: "대표메뉴", color: .sub, size: .small, style: .weak)
                }
                Text(menu.name)
                    .font(.bodySmallMedium)
                    .foregroundColor(.gray900)
                Text("\(menu.price)")
                    .font(.bodySmallSemibold)
                    .foregroundColor(.gray990)
            }
            
            Spacer()
            
            BakeryImageView(imageUrl: menu.imageUrl, placeholder: .ratio5_4)
                .frame(width: 100, height: 80)
                .cornerRadius(8)
        }
        .padding(.horizontal, 16)
    }
}
