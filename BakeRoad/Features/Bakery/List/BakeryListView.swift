//
//  BakeryListView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import SwiftUI

struct BakeryListView: View {
    @StateObject var viewModel: BakeryListViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                SkeletonListView()
                    .padding(.top, 16)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.bakeries.indices, id: \.self) { index in
                            let bakery = viewModel.bakeries[index]
                            BakeryCard(bakery: bakery)
                                .frame(height: 126)
                                .onAppear {
                                    // 마지막 2개 아이템에서만 페이징 트리거
                                    if index >= max(0, viewModel.bakeries.count - 2) && viewModel.hasNext {
                                        Task {
                                            await viewModel.loadMoreOnScroll()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    viewModel.didTapBakery(bakery)
                                }
                        }
                        
                        // 로딩 인디케이터
                        if viewModel.hasNext {
                            ProgressView()
                                .frame(height: 50)
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreOnScroll()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .padding(.top, 16)
            }
        }
        .background(Color.white)
        .task {
            await viewModel.loadInitial()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.didTapBackButton()
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
