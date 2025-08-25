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
                ForEach(Array(viewModel.notifications.enumerated()), id: \.element.id) { index, notification in
                    expandableNotificationItem(
                        notification: notification,
                        onToggle: {
                            viewModel.toggleExpanded(for: notification.id)
                        }
                    )
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
    
    private func expandableNotificationItem(notification: NotificationItem, showDivider: Bool = true, onToggle: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onToggle()
                }
            } label: {
                HStack {
                    Text(notification.title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: notification.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray500)
                        .frame(width: 16, height: 16)
                }
                .padding(16)
            }
            
            if notification.isExpanded,
               let description = notification.description {
                VStack(alignment: .leading, spacing: 0) {
                    Text(description)
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

#Preview {
    NotificationView(viewModel: NotificationViewModel())
}
