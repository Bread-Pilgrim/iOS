//
//  LoginView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 68) {
            Image("login")
            
            Button {
                viewModel.login()
            } label: {
                Image("kakaoLogin")
            }
        }
        .padding()
    }
}
