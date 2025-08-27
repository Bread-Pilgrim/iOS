//
//  BreadReportListView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/27/25.
//

import SwiftUI

struct BreadReportListView: View {
    @StateObject var viewModel: BreadReportListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        viewModel.navigateBack()
                    } label: {
                        Image("arrowLeft")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(16)
                
                Text("빵말정산")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            if viewModel.breadReportList.isEmpty && !viewModel.isLoading {
                VStack(alignment: .center, spacing: 4) {
                    Text("월간 빵말정산 리포트가 없습니다.")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                    Text("다녀온 빵집의 리뷰를 남겨보세요 🥨")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray40)
                .cornerRadius(12)
                .padding(16)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.breadReportList) { item in
                            breadReportListItem(item)
                                .onAppear {
                                    guard viewModel.breadReportList.last == item,
                                          !viewModel.isLoading,
                                          viewModel.nextCursor != nil else { return }
                                    Task { await viewModel.loadMoreBreadReportList() }
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
    }
    
    private func breadReportListItem(_ item: BreadReportListItem) -> some View {
        VStack(spacing: 0) {
            Button {
                viewModel.navigateToReport(item)
            } label: {
                HStack {
                    Text(item.id)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray500)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
            
            Rectangle()
                .fill(Color.gray50)
                .frame(height: 1)
        }
    }
}
