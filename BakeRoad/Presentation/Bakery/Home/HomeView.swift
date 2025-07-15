//
//  HomeView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HeaderView {
                Image("header")
            } rightItem: {
                Button {
                    print("취향")
                } label: {
                    Text("내 취향 변경")
                        .font(.bodySmallSemibold)
                        .foregroundColor(.gray800)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
