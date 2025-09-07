//
//  LoginView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 68) {
            Image("login")
            
            VStack(spacing: 16) {
                Button {
                    viewModel.login()
                } label: {
                    Image("kakaoLogin")
                        .resizable()
                }
                .frame(height: 44)
                .cornerRadius(10)
                
                SignInWithAppleButton { requst in
                    requst.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    viewModel.loginWithApple(result)
                }
                .frame(height: 44)
                .cornerRadius(10)
                .overlay {
                    Image("appleLogin")
                        .resizable()
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 16)
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
    }
}
