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
                    HStack {
                        Spacer()
                        Image(systemName: bakery.isLike ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        BakeryOpenStatusChip(
                            openStatus: BakeryOpenStatus(rawValue: bakery.openStatus),
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
                    Image("reviewStar")
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

#Preview {
    ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .center, spacing: 16) {
            ForEach(Bakery.mockData, id: \.id) { bakery in
                BakeryCard(bakery: bakery)
                    .frame(height: 126)
            }
        }
        .padding(.horizontal, 16)
    }
}


struct SignatureMenuChipsView: View {
    let signatureMenus: [Bakery.SignatureMenu]
    
    var body: some View {
        // 자동 줄바꿈이 필요한 경우 LazyVGrid, 혹은 Custom FlowLayout 사용 고려
        VStack(alignment: .leading, spacing: 8) {
            // 두 줄 예시
            HStack(spacing: 8) {
                ForEach(0..<min(2, signatureMenus.count), id: \.self) { index in
                    BakeRoadChip(
                        title: signatureMenus[index].menuName,
                        color: .lightGray,
                        size: .small,
                        style: .weak
                    )
                }
            }
            if signatureMenus.count > 2 {
                HStack(spacing: 8) {
                    ForEach(2..<signatureMenus.count, id: \.self) { index in
                        BakeRoadChip(
                            title: signatureMenus[index].menuName,
                            color: .lightGray,
                            size: .small,
                            style: .weak
                        )
                    }
                }
            }
        }
    }
}
