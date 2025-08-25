//
//  UserInfoView.swift
//  BakeRoad
//
//  Created by Claude on 8/24/25.
//

import SwiftUI

struct UserInfoView: View {
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    showSettings = true
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
    }
    
    private var profileSection: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.primary100)
                .frame(width: 56, height: 56)
                .overlay(
                    Image("person")
                        .resizable()
                        .frame(width: 30, height: 30)
                )
            
            VStack(alignment: .leading, spacing: 10) {
                Text("김빵글")
                    .font(.bodyLargeSemibold)
                    .foregroundColor(.black)
                
                HStack {
                    Text("대표뱃지 없음")
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray600)
                    
                    Spacer()
                    
                    Button {
                        print("뱃지설정")
                    } label: {
                        Text("뱃지설정")
                            .underline()
                            .font(.bodyXsmallMedium)
                            .foregroundColor(.gray800)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var menuList: some View {
        VStack(spacing: 0) {
            menuItem(title: "빵말정산") {
                // 빵말정산 action
            }
            
            menuItem(title: "받은 빵지") {
                // 받은 빵지 action
            }
            
            menuItem(title: "내가 쓴 리뷰") {
                // 내가 쓴 리뷰 action
            }
            
            menuItem(title: "취향 변경", showDivider: false) {
                // 취향 변경 action
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

#Preview {
    UserInfoView()
}
