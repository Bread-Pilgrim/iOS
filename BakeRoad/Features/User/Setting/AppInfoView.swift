//
//  AppInfoView.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

struct AppInfoView: View {
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
                
                Text("앱 정보")
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
            
            // 앱 정보 내용
            VStack(spacing: 20) {
                // 앱 기본 정보
                VStack(spacing: 0) {
                    appInfoItem(title: "현재 절번", value: "iPhone (iOS \(UIDevice.current.systemVersion))")
                    appInfoItem(title: "앱 버전", value: "버전 \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")", showDivider: false)
                }
                .background(Color.gray40)
                .cornerRadius(20)
                
                // 사용자 정보
                VStack(spacing: 0) {
                    appInfoItem(
                        title: "사용자 정보",
                        value: "ID : bbanggj@kakao.com\n이름 : 이경희\n이메일 : bbanggj@kakao.com",
                        showDivider: false
                    )
                }
                .background(Color.gray40)
                .cornerRadius(20)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    private func appInfoItem(title: String, value: String, showDivider: Bool = true) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.bodyMediumSemibold)
                    .foregroundColor(.gray900)
                
                Spacer()
                
                Text(value)
                    .font(.bodyMediumRegular)
                    .foregroundColor(.gray700)
                    .multilineTextAlignment(.trailing)
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
    AppInfoView(onNavigateBack: {})
}