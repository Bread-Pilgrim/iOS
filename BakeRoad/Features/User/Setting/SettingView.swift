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
                
                settingMenuItem(title: "개인정보 처리방침") {
                    UIApplication.shared.open(URL(string: "https://elite-pet-b14.notion.site/261277e51b8680269c80dc42f91b20d0")!)
                }
                
                settingMenuItem(title: "로그아웃", isNavigation: false) {
                    viewModel.showLogoutAlert()
                }
                
                settingMenuItem(title: "계정 탈퇴", showDivider: false, isNavigation: false) {
                    viewModel.showDeleteAccountAlert()
                }
            }
            
            Spacer()
        }
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
        .overlay {
            if viewModel.showingLogoutAlert || viewModel.showingDeleteAccountAlert || viewModel.showingDeleteCompletionAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.dismissAlert()
                    }
                    .overlay {
                        if viewModel.showingLogoutAlert {
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
                        
                        Group {
                            if viewModel.showingDeleteAccountAlert {
                                BakeRoadAlert(
                                    title: "⚠️ 계정 탈퇴 안내",
                                    message: """
                                  • 빵글 계정 및 모든 기록(리뷰, 찜, 뱃지 등)이 삭제됩니다.
                                  • 삭제된 데이터는 복구할 수 없습니다.
                                  • 소셜 계정 연동도 함께 해제됩니다.
                                  """,
                                    primaryAction: AlertAction(title: "탈퇴하기") {
                                        viewModel.confirmDeleteAccount()
                                    },
                                    secondaryAction: AlertAction(title: "취소") {
                                        viewModel.dismissAlert()
                                    },
                                    layout: .horizontal
                                )
                            }
                            
                            if viewModel.showingDeleteCompletionAlert {
                                BakeRoadAlert(
                                    message: "계정 탈퇴가 완료되었습니다.\n그동안 빵글을 이용해 주셔서 감사합니다.\n언제든 다시 찾아와주세요!🍞",
                                    primaryAction: AlertAction(title: "확인") {
                                        viewModel.handleDeleteCompletion()
                                    },
                                    layout: .horizontal
                                )
                            }
                        }
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
