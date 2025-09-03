//
//  NotificationView.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var viewModel: NotificationViewModel
    
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
                
                Text("공지사항")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            VStack(spacing: 0) {
                ForEach(Array(viewModel.notices.enumerated()), id: \.element.id) { index, notice in
                    expandableNoticeItem(
                        notice: notice,
                        onToggle: {
                            viewModel.toggleExpanded(for: notice)
                        }
                    )
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
    
    private func expandableNoticeItem(notice: Notice, showDivider: Bool = true, onToggle: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onToggle()
                }
            } label: {
                HStack {
                    Text(notice.title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: notice.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray500)
                        .frame(width: 16, height: 16)
                }
                .padding(16)
            }
            
            if notice.isExpanded,
               !notice.contents.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text(notice.contents.joined(separator: "\n"))
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray800)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
            }
            
            if showDivider {
                Rectangle()
                    .fill(Color.gray50)
                    .frame(height: 1)
            }
        }
    }
}
