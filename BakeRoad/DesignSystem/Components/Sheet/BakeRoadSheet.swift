//
//  BakeRoadSheet.swift
//  BakeRoad
//
//  Created by 이현호 on 6/26/25.
//

import SwiftUI

struct SheetAction {
    let title: String
    let action: () -> Void
}

struct BakeRoadSheet<Content: View>: View {
    let title: String
    let message: String
    let primaryAction: SheetAction
    let secondaryAction: SheetAction?
    let content: Content

    init(
        title: String,
        message: String,
        primaryAction: SheetAction,
        secondaryAction: SheetAction? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headingSmallBold)
                    .foregroundColor(.gray990)

                Text(message)
                    .font(.bodyXsmallMedium)
                    .foregroundColor(.gray800)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // 사용자 정의 콘텐츠 삽입 영역
            content

            VStack(spacing: 8) {
                Button(action: primaryAction.action) {
                    Text(primaryAction.title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.primary500)
                        .cornerRadius(10)
                }

                if let secondary = secondaryAction {
                    Button(action: secondary.action) {
                        Text(secondary.title)
                            .font(.bodyMediumSemibold)
                            .foregroundColor(.primary500)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray200, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 8)
    }
}
