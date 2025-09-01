//
//  BadgeListView.swift
//  BakeRoad
//
//  Created by 이현호 on 9/1/25.
//

import SwiftUI

struct BadgeListView: View {
    @StateObject var viewModel: BadgeListViewModel
    
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
                
                Text("받은 뱃지")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
    }
}
