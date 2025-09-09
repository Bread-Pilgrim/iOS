//
//  BreadReportView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import SwiftUI
import Charts

struct BreadReportView: View {
    @StateObject var viewModel: BreadReportViewModel
    
    var body: some View {
        VStack(spacing: 20) {
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
                
                HStack(spacing: 10) {
                    if viewModel.canNavigateToPrevious() {
                        Button {
                            viewModel.navigateToPrevious()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray600)
                                .frame(width: 20, height: 20)
                        }
                    } else {
                        Spacer()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text(viewModel.currentReport.id)
                        .font(.bodyLargeSemibold)
                        .foregroundColor(.black)
                    
                    if viewModel.canNavigateToNext() {
                        Button {
                            viewModel.navigateToNext()
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray600)
                                .frame(width: 20, height: 20)
                        }
                    } else {
                        Spacer()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            if let breadReport = viewModel.breadReport {
                ScrollView {
                    VStack(spacing: 24) {
                        // 지주 간 부산 지역 Top3
                        RegionTopSection(visitedAreas: breadReport.visitedAreas)
                        
                        // 가장 많이 먹은 빵 종류 Top3
                        BreadTypeTopSection(breadTypes: breadReport.breadTypes)
                        
                        // 하루 평균 빵 구매량
                        DailyAveragePurchaseSection(dailyAvgQuantity: breadReport.dailyAvgQuantity,
                                                    monthlyConsumptionGap: breadReport.monthlyConsumptionGap,
                                                    totalQuantity: breadReport.totalQuantity,
                                                    totalVisitCount: breadReport.totalVisitCount)
                        
                        // 이번 달 빵 소비 금액
                        MonthlySpendingSection(month: breadReport.month,
                                               totalPrices: breadReport.totalPrices)
                        
                        // 요일별 빵 섭취 패턴
                        WeeklyPatternSection(weeklyDistribution: breadReport.weeklyDistribution)
                        
                        // 이번 달 내 빵글 활동 총정리
                        MonthlySummarySection(reviewCount: breadReport.reviewCount,
                                              totalQuantity: breadReport.totalQuantity,
                                              likedCount: breadReport.likedCount,
                                              receivedLikesCount: breadReport.receivedLikesCount)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            } else {
                Spacer()
            }
        }
        .background(Color.gray40)
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
    }
}

struct UnderlineText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.bodyXsmallMedium)
            .foregroundColor(.gray950)
            .background(
                Rectangle()
                    .frame(height: 6)
                    .foregroundColor(.primary50)
                    .offset(y: 0),
                alignment: .bottom
            )
    }
}

struct RegionTopSection: View {
    let visitedAreas: [String: Int]
    
    var sortedAreas: [(key: String, value: Int)] {
        visitedAreas.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("자주 간 부산 지역 Top3")
                .font(.bodyMediumSemibold)
                .foregroundColor(.black)
            
            if sortedAreas.isEmpty {
                VStack(spacing: 6) {
                    UnderlineText(text: "아직 방문한 지역이 없어요!")
                    Text("리뷰를 작성하고 빵말정산을 확인해보세요 😊")
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray990)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color.white)
                .cornerRadius(20)
                .cardShadow(level: 2)
            } else {
                HStack(spacing: 0) {
                    ForEach(Array(sortedAreas.prefix(3).enumerated()), id: \.offset) { index, area in
                        RegionRankCard(
                            rank: "\(index + 1)등",
                            district: area.key,
                            num: area.value
                        )
                        
                        if index < 2 {
                            Divider()
                                .padding(.vertical, 23)
                        }
                    }
                }
                .frame(height: 116)
                .background(Color.white)
                .cornerRadius(20)
                .cardShadow(level: 2)
            }
        }
    }
}

struct RegionRankCard: View {
    let rank: String
    let district: String
    let num: Int
    
    var body: some View {
        VStack(spacing: 6) {
            UnderlineText(text: rank)
            
            Text(district)
                .font(.bodyMediumSemibold)
                .foregroundColor(.gray950)
            
            BakeRoadChip(title: "\(num)회",
                         color: .main,
                         size: .large,
                         style: .fill)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BreadTypeTopSection: View {
    let breadTypes: [String: Int]
    
    var sortedBreadTypes: [(color: Color, type: String, num: Int)] {
        let colors: [Color] = [.primary500, .secondary500, .success500]
        
        return breadTypes
            .sorted { $0.value > $1.value }
            .prefix(3)
            .enumerated()
            .map { index, item in
                (
                    color: colors[index],
                    type: item.key,
                    num: item.value
                )
            }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("가장 많이 먹은 빵 종류 Top3")
                .font(.bodyMediumSemibold)
                .foregroundColor(.black)
            
            if sortedBreadTypes.isEmpty {
                VStack(spacing: 6) {
                    UnderlineText(text: "아직 먹은 빵 기록이 없어요!")
                    Text("리뷰를 작성하고 빵말정산을 확인해보세요 😊")
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray990)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color.white)
                .cornerRadius(20)
                .cardShadow(level: 2)
            } else {
                HStack(spacing: 18) {
                    Chart(sortedBreadTypes, id: \.type) { color, type, num in
                        SectorMark(
                            angle: .value("num", num),
                            angularInset: 3
                        )
                        .cornerRadius(2)
                        .foregroundStyle(color)
                    }
                    .chartLegend(.hidden)
                    .frame(width: 90, height: 90)
                    .padding(.vertical, 16)
                    .padding(.leading, 18.5)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(sortedBreadTypes.enumerated()), id: \.offset) { index, item in
                            LegendItem(color: item.color, text: item.type, num: item.num)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.trailing, 18.5)
                }
                .background(Color.white)
                .cornerRadius(20)
                .cardShadow(level: 2)
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    let num: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.bodyXsmallMedium)
                .foregroundColor(.gray800)
            
            Spacer()
            
            BakeRoadChip(title: "\(num)회", color: .gray, size: .small, style: .fill)
        }
    }
}

struct DailyAveragePurchaseSection: View {
    let dailyAvgQuantity: Double
    let monthlyConsumptionGap: Double
    let totalQuantity: Int
    let totalVisitCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("하루 평균 빵 구매량")
                .font(.bodyMediumSemibold)
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 0) {
                    Text("하루 평균")
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                        .padding(.trailing, 4)
                    Text(String(format: "%.1f", dailyAvgQuantity))
                        .font(.headingSmallBold)
                        .foregroundColor(.primary500)
                    Text("개")
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                if totalQuantity != 0 && totalVisitCount != 0 {
                    let underlineText = monthlyConsumptionGap > 0 ? "다른 빵글이들보다 \(monthlyConsumptionGap)개 더 먹었어요!" : "다른 빵글이들보다 \(-monthlyConsumptionGap)개 덜 먹었어요!"
                    
                    UnderlineText(text: underlineText)
                        .padding(.horizontal, 16)
                }
                
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.primary500)
                            .frame(width: 8, height: 8)
                        Text("이번달 총")
                            .font(.bodyXsmallRegular)
                            .foregroundColor(.gray600)
                        Text("\(totalQuantity)개 / \(totalVisitCount)일")
                            .font(.bodyXsmallSemibold)
                            .foregroundColor(.gray600)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow(level: 2)
        }
    }
}

struct MonthlySpendingSection: View {
    let month: Int
    let totalPrices: [Int]
    
    var data: [(month: Int, price: Int)] {
        guard totalPrices.count >= 3 else {
            return (0..<3).compactMap { index in
                let targetMonth = month - (2 - index)
                return (month: targetMonth, price: 0)
            }
        }
        
        return (0..<3).compactMap { index in
            let targetMonth = month - (2 - index)
            let price = totalPrices[index]
            return (month: targetMonth, price: price)
        }
    }
    
    var currentMonthPrice: Double {
        guard totalPrices.count >= 3 else { return 0.0 }
        return Double(totalPrices[2]) / 10000.0
    }
    
    var monthlyComparison: (amount: Double, isIncrease: Bool) {
        guard totalPrices.count >= 3 else { return (0.0, false) }
        
        let current = totalPrices[2]
        let previous = totalPrices[1]
        let difference = abs(current - previous)
        let amount = Double(difference) / 10000.0
        
        return (
            amount: amount,
            isIncrease: current > previous
        )
    }
    
    var body: some View {
        let startXScale = (Double(data.first?.month ?? 1) - 0.5)
        let endXScale = (Double(data.last?.month ?? 12) + 0.5)
        let noData = totalPrices.allSatisfy { $0 == 0 } || totalPrices.count < 3
        
        VStack(alignment: .leading, spacing: 8) {
            Text("이번 달 빵 소비 금액")
                .font(.bodyMediumSemibold)
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("총")
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                    Text(String(format: "%.1f", currentMonthPrice))
                        .font(.headingSmallBold)
                        .foregroundColor(.primary500)
                    Text("만원")
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
                
                if !noData {
                    UnderlineText(text: "전달 대비 \(String(format: "%.1f", monthlyComparison.amount))만원 \(monthlyComparison.isIncrease ? "더" : "덜") 썼어요!")
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
                
                VStack(spacing: 8) {
                    if noData {
                        VStack {
                            Spacer()
                            
                            Rectangle()
                                .fill(Color.gray200)
                                .frame(height: 1.6)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 85)
                        .padding(.horizontal, 96)
                    } else {
                        Chart(data, id: \.month) { month, price in
                            AreaMark(
                                x: .value("month", month),
                                yStart: .value("start", 0),
                                yEnd: .value("price", price)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.primary500.opacity(0.1),
                                        Color.primary500.opacity(0.01)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                            
                            LineMark(
                                x: .value("month", month),
                                y: .value("price", price)
                            )
                            .foregroundStyle(Color.primary500)
                            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                            .interpolationMethod(.catmullRom)
                        }
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .chartXScale(domain: startXScale...endXScale) // X축 범위를 좁혀서 차트가 중앙에 오도록
                        .frame(height: 85)
                        .padding(.horizontal, 54)
                    }
                    
                    HStack {
                        ForEach(data, id: \.month) { month, price in
                            VStack(spacing: 2) {
                                Text("\(month)월")
                                    .font(.body3xsmallMedium)
                                    .foregroundColor(month == self.month ? .primary500 : .gray800)
                                Text(String(format: "%.1f만원", Double(price) / 10000))
                                    .font(.bodySmallSemibold)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 64.5)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
            }
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow(level: 2)
        }
    }
}

struct WeeklyPatternSection: View {
    let weeklyDistribution: [String: Int]
    
    var data: [(day: String, num: Int)] {
        let dayOrder = ["0", "1", "2", "3", "4", "5", "6"]
        
        return dayOrder.map { key in
            let count = weeklyDistribution[key] ?? 0
            let dayName = dayName(from: Int(key) ?? 0)
            return (day: dayName, num: count)
        }
    }
    
    private func dayName(from number: Int) -> String {
        switch number {
        case 0: return "월"
        case 1: return "화"
        case 2: return "수"
        case 3: return "목"
        case 4: return "금"
        case 5: return "토"
        case 6: return "일"
        default: return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("요일별 빵 섭취 패턴")
                .font(.bodyMediumSemibold)
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                let maxNum = data.max(by: { $0.num < $1.num })?.num ?? 0
                
                if maxNum == 0 {
                    VStack(spacing: 6) {
                        UnderlineText(text: "이번 달엔 아직 빵을 먹지 않았어요!")
                        Text("리뷰를 작성하고 빵말정산을 확인해보세요😊")
                            .font(.bodyXsmallMedium)
                            .foregroundColor(.gray990)
                    }
                    .padding(.vertical, 36)
                }
                
                Chart(data, id: \.day) { data in
                    BarMark(
                        x: .value("day", data.day),
                        y: .value("num", maxNum == 0 ? 0.1 : max(Double(maxNum)*0.05, Double(data.num)))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle({
                        if maxNum == 0 {
                            return AnyShapeStyle(Color.gray50)
                        } else if data.num == maxNum {
                            return AnyShapeStyle(LinearGradient(colors: [.primary600, .primary500, .primary400],
                                                                startPoint: .top,
                                                                endPoint: .bottom))
                        } else if data.num == 0 {
                            return AnyShapeStyle(Color.gray50)
                        } else {
                            return AnyShapeStyle(Color.primary200)
                        }
                    }())
                    
                    if data.num == maxNum && maxNum > 0 {
                        PointMark(
                            x: .value("day", data.day),
                            y: .value("num", Double(data.num))
                        )
                        .annotation(position: .top, spacing: 8) {
                            Image("first")
                                .resizable()
                                .frame(width: 34, height: 30)
                        }
                        .opacity(0)
                    }
                }
                .chartYScale(domain: 0...max(1, maxNum))
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .padding(.horizontal, 16)
                .padding(.top, maxNum == 0 ? 0 : 54)
                
                HStack(spacing: 0) {
                    ForEach(data, id: \.day) { data in
                        Text(data.day)
                            .font(.body2xsmallSemibold)
                            .foregroundColor(.gray800)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(height: 180)
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow(level: 2)
        }
    }
}

struct MonthlySummarySection: View {
    let reviewCount: Int
    let totalQuantity: Int
    let likedCount: Int
    let receivedLikesCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이번 달 내 빵글 활동 총정리")
                .font(.bodyMediumSemibold)
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    SummaryCard(title: "내가 남긴 리뷰", count: reviewCount)
                    Divider().padding(.top, 16)
                    SummaryCard(title: "내가 먹은 빵", count: totalQuantity)
                }
                
                Divider().padding(.horizontal, 16)
                
                HStack(spacing: 0) {
                    SummaryCard(title: "내가 남긴 좋아요", count: likedCount)
                    Divider().padding(.bottom, 16)
                    SummaryCard(title: "내가 받은 좋아요", count: receivedLikesCount)
                }
            }
            .frame(height: 196)
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow(level: 2)
        }
    }
}

struct SummaryCard: View {
    let title: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.bodyXsmallSemibold)
                .foregroundColor(.gray950)
            
            BakeRoadChip(title: "\(count)개",
                         color: .main,
                         size: .large,
                         style: .fill)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
