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
        SignInWithAppleButton { requst in
            requst.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            print(result)
        }
        
        VStack(spacing: 68) {
            Image("login")
            
            Button {
                viewModel.login()
                print("카카오 로그인")
            } label: {
                Image("kakaoLogin")
            }
        }
        .padding()
    }
}

struct ExampleView: View {
    var body: some View {
        VStack {
            VStack(spacing: 68) {
                Image("login")
                
                VStack(spacing: 10) {
                    SignInWithAppleButton { requst in
                        requst.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        print(result)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    .cornerRadius(10)
                    
                    Button {
                        print("카카오 로그인")
                    } label: {
                        Image("kakaoLogin")
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview(body: {
    ExampleView()
})
