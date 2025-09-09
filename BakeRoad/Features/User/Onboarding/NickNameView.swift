//
//  NickNameView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/4/25.
//

import SwiftUI

struct NickNameView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    var onComplete: ([Badge]) -> Void
    
    @State private var nickname: String = ""
    @State private var isCheckMsg: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    private var isValid: Bool {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        nickname.trimmingCharacters(in: .whitespacesAndNewlines).count > 8
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 6) {
                Text("회원님의 닉네임을 설정해주세요.")
                    .font(.headingLargeBold)
                    .foregroundColor(.black)
                Text("취향이 담긴 닉네임을 추천드려요!")
                    .font(.bodySmallRegular)
                    .foregroundColor(.gray800)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("닉네임")
                    .font(.bodyXsmallRegular)
                    .foregroundColor(.gray990)
                
                BakeRoadTextField(title: "",
                                  placeholder: "빵글이에용",
                                  description: "nil",
                                  showTitle: false,
                                  showDescription: false,
                                  isEssential: false,
                                  text: $nickname)
                .focused($isTextFieldFocused)
                .padding(.bottom, 4)
                
                if !isCheckMsg.isEmpty {
                    Text(isCheckMsg)
                        .font(.body2xsmallRegular)
                        .foregroundColor(.error400)
                }
            }
            .padding(.top, 44)
            
            Spacer()
            
            BakeRoadSolidButton(title: "빵글 시작하기",
                                style: .primary,
                                size: .xlarge,
                                isDisabled: isValid) {
                Task { @MainActor in
                    if let badges = await viewModel.submitOnboarding(nickname) {
                        onComplete(badges)
                    } else {
                        isCheckMsg = viewModel.errorMessage ?? ""
                        isTextFieldFocused = true
                    }
                }
            }
        }
        .padding(.top, 11)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }
}
