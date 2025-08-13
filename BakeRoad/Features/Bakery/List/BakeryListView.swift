//
//  BakeryListView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import SwiftUI

struct BakeryListView: View {
    @StateObject var viewModel: BakeryListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.bakeries) { bakery in
                        BakeryCard(bakery: bakery)
                            .frame(height: 126)
                            .task {
                                await viewModel.loadMoreIfNeeded(currentItem: bakery)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .padding(.top, 16)
        }
        .background(Color.white)
        .task {
            await viewModel.loadInitial()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("arrowLeft")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("내 취향 빵집")
                    .font(.headingSmallBold)
                    .foregroundColor(.gray990)
            }
        }
    }
}
