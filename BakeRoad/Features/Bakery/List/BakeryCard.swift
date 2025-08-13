//
//  BakeryCard.swift
//  BakeRoad
//
//  Created by 이현호 on 7/21/25.
//

import SwiftUI

struct BakeryCard: View {
    let bakery: Bakery
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack() {
                BakeryImageView(
                    imageUrl: bakery.imgUrl,
                    placeholder: .ratio5_4
                )
                .cornerRadius(12)
                
                VStack {
                    Spacer()
                    HStack {
                        BakeryOpenStatusChip(
                            openStatus: bakery.openStatus,
                            style: .fill
                        )
                        Spacer()
                    }
                    .padding(6)
                }
            }.frame(width: 148)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bakery.name)
                    .font(.bodyXsmallSemibold)
                    .foregroundColor(.gray990)
                
                HStack(spacing: 0) {
                    Image("fillStar")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text(String(format: "%.1f", bakery.rating))
                        .font(.body2xsmallMedium)
                        .foregroundColor(.gray950)
                        .padding(.leading, 4)
                    Text("(리뷰 \(bakery.reviewCount.formattedWithSeparator))")
                        .font(.body2xsmallRegular)
                        .foregroundColor(.gray400)
                        .padding(.leading, 2)
                }
                
                HStack(spacing: 2) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("\(bakery.gu), \(bakery.dong)")
                        .font(.body2xsmallMedium)
                        .foregroundColor(.gray950)
                }
                .padding(.bottom, 8)
                
                SignatureMenuChipsView(signatureMenus: bakery.signatureMenus)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SignatureMenuChipsView: View {
    let signatureMenus: [String]
    
    private func chip(_ name: String) -> some View {
        BakeRoadChip(title: name, color: .lightGray, size: .small, style: .weak)
    }
    
    var body: some View {
        let menus = Array(signatureMenus.prefix(3))
        
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                ForEach(menus, id: \.self) { chip($0) }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(menus.prefix(2), id: \.self) { chip($0) }
                }
                if menus.count > 2 {
                    HStack(spacing: 8) { chip(menus[2]) }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let first = menus.first {
                    HStack(spacing: 8) { chip(first) }
                }
                HStack(spacing: 8) {
                    ForEach(menus.dropFirst(), id: \.self) { chip($0) }
                }
            }
        }
    }
}
