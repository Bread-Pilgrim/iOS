//
//  BakeryListView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import SwiftUI

struct BakeryListView: View {
    var bakeries: [Bakery] = Bakery.mockData

    var body: some View {
        VStack {
            HeaderView {
                Button {
                    print("뒤로가기")
                } label: {
                    Image("arrowLeft")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.leading, 14)
                .padding(.vertical, 16)
            } centerItem: {
                Text("내 취향 빵집")
                    .font(.headingMediumBold)
                    .foregroundColor(.gray990)
            }

            // 리스트
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(bakeries, id: \.id) { bakery in
                        BakeryCard(bakery: bakery)
                            .frame(height: 126)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .padding(.top, 16)
        }
        .background(Color.white)
    }
}

#Preview {
    BakeryListView()
}
