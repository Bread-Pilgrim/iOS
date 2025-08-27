//
//  BreadReportView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import SwiftUI

struct BreadReportView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // 지주간 부산 지역 Top3
                RegionTopSection()
                
                // 가장 많이 먹은 빵 종류 Top3
                BreadTypeTopSection()
                
                // 하루 평균 빵 구매량
                DailyAveragePurchaseSection()
                
                // 이번 달 빵 소비 금액
                MonthlySpendingSection()
                
                // 요일별 빵 섭취 패턴
                WeeklyPatternSection()
                
                // 이번 달 내 빵굴 활동 총정리
                MonthlySummarySection()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct RegionTopSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("지주간 부산 지역 Top3")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            HStack(spacing: 24) {
                RegionRankCard(rank: "1등", district: "해운대구", position: "1위")
                RegionRankCard(rank: "2등", district: "남구", position: "1위")
                RegionRankCard(rank: "3등", district: "수영구", position: "1위")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct RegionRankCard: View {
    let rank: String
    let district: String
    let position: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(rank)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            Text(district)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            Text(position)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.orange)
                .cornerRadius(12)
        }
    }
}

struct BreadTypeTopSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("가장 많이 먹은 빵 종류 Top3")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            HStack(spacing: 24) {
                // 파이 차트 영역
                ZStack {
                    Circle()
                        .trim(from: 0, to: 0.6)
                        .stroke(Color.orange, lineWidth: 40)
                        .rotationEffect(.degrees(-90))
                    
                    Circle()
                        .trim(from: 0.6, to: 0.8)
                        .stroke(Color.blue, lineWidth: 40)
                        .rotationEffect(.degrees(-90 + 216))
                    
                    Circle()
                        .trim(from: 0.8, to: 1.0)
                        .stroke(Color.green, lineWidth: 40)
                        .rotationEffect(.degrees(-90 + 288))
                }
                .frame(width: 120, height: 120)
                
                // 범례
                VStack(alignment: .leading, spacing: 12) {
                    LegendItem(color: .orange, text: "페이스트리류", rank: "1위")
                    LegendItem(color: .blue, text: "클래식 & 레트로 빵", rank: "1위")
                    LegendItem(color: .green, text: "구움과자류", rank: "1위")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    let rank: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.black)
            
            Spacer()
            
            Text(rank)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.black)
                .cornerRadius(8)
        }
    }
}

struct DailyAveragePurchaseSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("하루 평균 빵 구매량")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 4) {
                    Text("하루 평균")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("3.32")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)
                    Text("개")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                
                Text("다른 빵굴이들보다 2개 더 먹었어요!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 8, height: 8)
                    Text("이번달 총 10개 / 3일")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct MonthlySpendingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("이번 달 빵 소비 금액")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 4) {
                    Text("총")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("5.5")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)
                    Text("만원")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                
                Text("전달 대비 1.2만원 더 썼어요!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            // 차트 영역
            VStack(spacing: 12) {
                // 그래프 선
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 60))
                        path.addLine(to: CGPoint(x: 120, y: 80))
                        path.addLine(to: CGPoint(x: 240, y: 20))
                    }
                    .stroke(Color.orange, lineWidth: 3)
                    
                    // 그래프 배경 영역
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 60))
                        path.addLine(to: CGPoint(x: 120, y: 80))
                        path.addLine(to: CGPoint(x: 240, y: 20))
                        path.addLine(to: CGPoint(x: 240, y: 100))
                        path.addLine(to: CGPoint(x: 0, y: 100))
                        path.closeSubpath()
                    }
                    .fill(LinearGradient(
                        colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                }
                .frame(height: 100)
                
                // 월별 라벨
                HStack {
                    VStack {
                        Text("5월")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text("0.0만원")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("6월")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text("1.2만원")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("7월")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("5.5만원")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct WeeklyPatternSection: View {
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    let values: [CGFloat] = [0.8, 0.6, 0.4, 1.0, 0.7, 0.7, 0.5]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("요일별 빵 섭취 패턴")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 8) {
                        Rectangle()
                            .fill(day == "목" ? Color.orange : Color.orange.opacity(0.3))
                            .frame(width: 32, height: values[index] * 100)
                            .cornerRadius(4)
                        
                        Text(day)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(height: 120)
            
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("1위")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.black)
                        .cornerRadius(6)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct MonthlySummarySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("이번 달 내 빵굴 활동 총정리")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                SummaryCard(title: "내가 남긴 리뷰", count: "1개")
                SummaryCard(title: "내가 먹은 빵", count: "1개")
                SummaryCard(title: "내가 남긴 좋아요", count: "1개")
                SummaryCard(title: "내가 받은 좋아요", count: "1개")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct SummaryCard: View {
    let title: String
    let count: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text(count)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.orange)
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview {
    BreadReportView()
}

