//
//  EventPopupSheet.swift
//  BakeRoad
//
//  Created by 이현호 on 9/4/25.
//

import SwiftUI

struct EventPopupSheet: View {
    let eventPopup: EventPopup
    @Binding var isPresented: Bool
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Spacer()
                
                Button("닫기") {
                    isPresented = false
                }
                .foregroundColor(.white)
            }
            .padding(16)
            
            VStack(spacing: 0) {
                Text(eventPopup.title)
                    .font(.headingSmallBold)
                    .foregroundColor(.gray990)
                    .padding(.top, 24)
                
                Text("\(eventPopup.startDate) ~ \(eventPopup.endDate)")
                    .font(.body2xsmallMedium)
                    .foregroundColor(.gray800)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                Text(eventPopup.address)
                    .font(.body2xsmallMedium)
                    .foregroundColor(.gray800)
                
                BakeryImageView(
                    imageUrl: eventPopup.eventImg,
                    placeholder: .ratio3_2
                )
                .padding(.vertical, 24)
                
                HStack(spacing: 8) {
                    BakeRoadOutlinedButton(title: "오늘 안보기", style: .assistive, size: .large) {
                        todayNotShow()
                    }
                    
                    BakeRoadSolidButton(title: "자세히 보기", style: .primary, size: .large) {
                        openURL(URL(string: eventPopup.readMoreLink)!)
                    }
                }
                .padding(.bottom, 14)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
            .background(.white)
            .cornerRadius(20)
            .ignoresSafeArea()
        }
    }
    
    private func todayNotShow() {
        var component = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        component.timeZone = TimeZone(abbreviation: "KST")
        let dateWithoutTime = Calendar.current.date(from: component)!
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: dateWithoutTime)
        UserDefaults.standard.set(nextDate, forKey: "todayNotShow")
        isPresented = false
    }
}
