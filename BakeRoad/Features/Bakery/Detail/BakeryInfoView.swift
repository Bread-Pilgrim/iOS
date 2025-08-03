//
//  BakeryInfoView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/23/25.
//

import SwiftUI

struct BakeryInfoView: View {
    let bakery: BakeryDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(bakery.name)
                    .font(.bodyXlargeSemibold)
                
                HStack(spacing: 2) {
                    Image("fillStar")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(String(format: "%.1f", bakery.rating))")
                        .font(.bodySmallSemibold)
                        .foregroundColor(.gray950)
                    Text("(\(bakery.reviewCount.formattedWithSeparator)개)")
                        .font(.bodySmallSemibold)
                        .foregroundColor(.gray950)
                }
            }
            
            BakeRoadSolidButton(
                title: "리뷰 작성하기",
                style: .primary,
                size: .medium) {
                    print("리뷰 작성")
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
            
            Divider()
                .foregroundColor(.gray50)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text(bakery.address)
                        .font(.bodyXsmallMedium)
                    
                    Spacer()
                    
                    Button {
                        print("열려라 지도")
                    } label: {
                        Text("지도 보기")
                            .font(.body2xsmallMedium)
                            .foregroundColor(.gray950)
                            .underline()
                    }
                }
                
                OperatingHoursView(operatingHours: bakery.operatingHours)
                
                if let phone = bakery.phone {
                    HStack(spacing: 4) {
                        Image("ringPhone")
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text(phone)
                            .font(.bodyXsmallMedium)
                            .foregroundColor(.gray800)
                        
                        Spacer()
                        
                        Button {
                            print("전화 연결")
                        } label: {
                            Text("연결")
                                .font(.body2xsmallMedium)
                                .foregroundColor(.gray950)
                                .underline()
                        }
                        
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct OperatingHoursView: View {
    let operatingHours: [BakeryDetail.OperatingHour]
    @State private var isExpanded: Bool = false
    
    init(operatingHours: [BakeryDetail.OperatingHour]) {
        self.operatingHours = operatingHours.sortedByWeekday()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 0) {
                Image("ringClock")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.trailing, 4)
                
                if let firstDay = operatingHours.first {
                    Text("\(firstDay.displayDayString) \(firstDay.openTime) ~ \(firstDay.closeTime)")
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray800)
                        .padding(.trailing, 6)
                }
                
                BakeRoadChip(
                    title: operatingHours.closedDaysLabel(),
                    color: .lightGray,
                    size: .small,
                    style: .weak
                )
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.black)
            }
            .onTapGesture {
                isExpanded.toggle()
            }
            
            if isExpanded {
                ForEach(operatingHours.dropFirst(), id: \.dayOfWeek) { day in
                    if day.isOpened {
                        Text("\(day.displayDayString) \(day.openTime) ~ \(day.closeTime)")
                            .font(.bodyXsmallMedium)
                            .foregroundColor(.gray800)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    BakeryInfoView(bakery: BakeryDetail.mockData)
}
