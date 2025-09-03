//
//  SettingView.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject var viewModel: SettingViewModel
    
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
                
                Text("설정")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            VStack(spacing: 0) {
                settingMenuItem(title: "공지사항") {
                    viewModel.navigateToNotifications()
                }
                
                settingMenuItem(title: "앱 정보") {
                    viewModel.navigateToAppInfo()
                }
                
                settingMenuItem(title: "로그아웃", isNavigation: false) {
                    viewModel.showLogoutAlert()
                }
                
                settingMenuItem(title: "계정 탈퇴", showDivider: false, isNavigation: false) {
                    print("탈퇴")
                }
            }
            
            Spacer()
        }
        .overlay {
            if viewModel.showingLogoutAlert {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.dismissAlert()
                    }
                    .overlay {
                        BakeRoadAlert(
                            title: "로그아웃 하시겠어요?",
                            primaryAction: AlertAction(title: "로그아웃") {
                                viewModel.logout()
                            },
                            secondaryAction: AlertAction(title: "취소") {
                                viewModel.dismissAlert()
                            },
                            layout: .horizontal
                        )
                    }
            }
        }
    }
    
    private func settingMenuItem(title: String, showDivider: Bool = true, isNavigation: Bool = true, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(isNavigation ? .gray900 : .gray400)
                    
                    Spacer()
                    
                    if isNavigation {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray500)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
            
            if showDivider {
                Rectangle()
                    .fill(Color.gray50)
                    .frame(height: 1)
            }
        }
    }
}
