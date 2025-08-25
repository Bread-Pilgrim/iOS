//
//  NotificationView.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var viewModel: NotificationViewModel
    let onNavigateBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 네비게이션 헤더
            HStack {
                Button(action: onNavigateBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Spacer()
                
                Text("공지사항")
                    .font(.bodyLargeSemibold)
                    .foregroundColor(.black)
                
                Spacer()
                
                // 균형을 위한 투명 버튼
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.clear)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            // 알림 설정 옵션들
            VStack(spacing: 0) {
                notificationToggleItem(
                    title: "실수록 안기 딱딱한 정보 업데이트 안내",
                    isOn: $viewModel.isServiceUpdateEnabled
                )
                
                notificationToggleItem(
                    title: "리뷰 작성 이벤트 안내",
                    isOn: $viewModel.isReviewEventEnabled
                )
                
                notificationToggleItem(
                    title: "일부 배정 운영시간 변경 안내",
                    isOn: $viewModel.isOperationTimeEnabled,
                    showDivider: false
                )
            }
            .background(Color.gray40)
            .cornerRadius(20)
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    private func notificationToggleItem(title: String, isOn: Binding<Bool>, showDivider: Bool = true) -> some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                        .multilineTextAlignment(.leading)
                    
                    if title.contains("실수록") {
                        Text("실수록 안기 딱딱한 정보에 대한 새로운 내용을 10일마다 알려드립니다.")
                            .font(.bodyXsmallRegular)
                            .foregroundColor(.gray600)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if title.contains("운영시간") {
                        Text("우리 빵집 중 일부 운영시간이 변경 중일때, 정보를 미리 주시겠습니다.")
                            .font(.bodyXsmallRegular)
                            .foregroundColor(.gray600)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: isOn)
                    .toggleStyle(SwitchToggleStyle())
            }
            .padding(20)
            
            if showDivider {
                Rectangle()
                    .fill(Color.gray50)
                    .frame(height: 1)
            }
        }
    }
}

#Preview {
    NotificationView(viewModel: NotificationViewModel(), onNavigateBack: {})
}