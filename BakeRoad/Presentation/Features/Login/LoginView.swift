//
//  LoginView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/2/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        VStack(spacing: 68) {
            Image("login")

            Button {
                appViewModel.login()
            } label: {
                Image("kakaoLogin")
            }
        }
        .padding()
    }
}
