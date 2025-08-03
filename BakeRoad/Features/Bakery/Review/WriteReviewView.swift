//
//  WriteReviewView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/30/25.
//

import SwiftUI

struct WriteReviewView: View {
    var bakeryMenus: [BakeryMenu]
    
    @State private var onlyMe = true
    @State private var rating: Double = 2.5
    @State private var reviewContent: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView {
                BakeRoadTextButton(title: "이전", type: .assistive, size: .medium) {
                    print("이전")
                }
            } centerItem: {
                Text("리뷰 쓰기")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
            } rightItem: {
                HStack(spacing: 8) {
                    Toggle("", isOn: $onlyMe)
                        .toggleStyle(SwitchToggleStyle(tint: Color.primary500))
                    
                    Text("나만보기")
                        .font(.bodySmallSemibold)
                        .foregroundColor(.gray800)
                }
            }
            .padding(.horizontal, 16)
            
            ReviewStarRatingView(rating: $rating)
                .padding(10)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(bakeryMenus) { menu in
                        BakeRoadChip(title: menu.name,
                                     color: .lightGray,
                                     size: .large,
                                     style: .weak)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .foregroundColor(.gray50)
            
            BakeRoadBox(placeholder: "정성스러운 리뷰는 다른 유저들의 빵 여행에 큰 도움이 됩니다.\n맛, 분위기, 추천 포인트를 자유롭게 남겨주세요!\n(최소 10자 이상 작성해주세요)",
                        isEssential: false,
                        showsLetterCount: true,
                        characterLimit: 300,
                        text: $reviewContent)
            .frame(height: 150)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            BakeRoadTextButton(title: "사진 추가하기",
                               type: .primary,
                               size: .medium) {
                AnyView(
                    Image(systemName: "plus")
                        .foregroundColor(.primary500)
                        .frame(width: 20, height: 20)
                )
            } action: {
                print("사진 추가하기")
            }
            
            Spacer()
        }
    }
}

#Preview {
    WriteReviewView(bakeryMenus: BakeryMenu.mockData)
}
