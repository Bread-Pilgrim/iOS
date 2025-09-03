//
//  UserInfoView.swift
//  BakeRoad
//
//  Created by Claude on 8/24/25.
//

import SwiftUI

import Kingfisher

struct UserInfoView: View {
    @StateObject var viewModel: UserInfoViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.navigateToSettings()
                }) {
                    Image("setting")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 12) {
                profileSection
                    .background(Color.gray40)
                    .cornerRadius(20)
                
                menuList
                    .background(Color.gray40)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            Task { await viewModel.loadUserProfile() }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
    }
    
    private var profileSection: some View {
        Group {
            if let userProfile = viewModel.userProfile {
                HStack(spacing: 12) {
                    if let url = userProfile.profileImg {
                        KFImage(URL(string: url))
                            .placeholder {
                                Circle()
                                    .fill(Color.primary100)
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        Image("person")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    )
                            }
                            .resizable()
                            .cacheMemoryOnly()
                            .fade(duration: 0.25)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.primary100)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image("person")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(userProfile.nickname)
                            .font(.bodyLargeSemibold)
                            .foregroundColor(.black)
                        
                        HStack {
                            if userProfile.isRepresentative {
                                Text(userProfile.badgeName)
                                    .font(.bodyXsmallMedium)
                                    .foregroundColor(.gray600)
                                
                                Spacer()
                            } else {
                                Text("대표뱃지 없음")
                                    .font(.bodyXsmallMedium)
                                    .foregroundColor(.gray600)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.navigateToReceivedBadges()
                                } label: {
                                    Text("뱃지설정")
                                        .underline()
                                        .font(.bodyXsmallMedium)
                                        .foregroundColor(.gray800)
                                }
                            }
                        }
                    }
                }
            } else {
                SkeletonProfileView()
                    .background(Color.gray40)
                    .cornerRadius(20)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var menuList: some View {
        VStack(spacing: 0) {
            menuItem(title: "빵말정산") {
                viewModel.navigateToBreadReport()
            }
            
            menuItem(title: "받은 뱃지") {
                viewModel.navigateToReceivedBadges()
            }
            
            menuItem(title: "내가 쓴 리뷰") {
                viewModel.navigateToMyReviews()
            }
            
            menuItem(title: "취향 변경", showDivider: false) {
                viewModel.navigateToPreferenceChange()
            }
        }
    }
    
    private func menuItem(title: String, showDivider: Bool = true, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray500)
                }
                .padding(20)
            }
            
            if showDivider {
                Rectangle()
                    .fill(Color.gray50)
                    .frame(height: 1)
            }
        }
    }
}
