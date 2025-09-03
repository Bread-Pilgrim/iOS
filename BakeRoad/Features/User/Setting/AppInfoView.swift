//
//  AppInfoView.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

struct AppInfoView: View {
    let onNavigateBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        onNavigateBack()
                    } label: {
                        Image("arrowLeft")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(16)
                
                Text("앱 정보")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("장치 정보")
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                    Text("iPhone (\(UIDevice.current.systemVersion))")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray800)
                }
                .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.gray50)
                    .frame(height: 1)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("앱 버전")
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray900)
                    Text("버전 \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray800)
                }
                .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.gray50)
                    .frame(height: 1)
            }
            .padding(.vertical, 20)
            
            Spacer()
        }
    }
}
