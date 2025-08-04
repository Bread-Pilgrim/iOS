//
//  OnboardingView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.currentStep.titleText)
                    .font(.headingLargeBold)
                    .foregroundColor(.black)
                Text(viewModel.currentStep.subtitleText)
                    .font(.bodySmallRegular)
                    .foregroundColor(.gray800)
            }
            .padding(.top, 67)
            .padding(.leading, 16)
            
            StepIndicatorView(currentStep: viewModel.currentStep)
                .padding(.top, 25)
                .padding(.leading, 16)
            
            PreferenceSelectionView(step: viewModel.currentStep,
                                    viewModel: viewModel)
            .padding(.top, 42)
            
            Spacer()
            
            HStack {
                if viewModel.currentStep != .breadType {
                    BakeRoadOutlinedButton(title: "이전",
                                           style: .primary,
                                           size: .large) {
                        if let prevStep = OnboardingStep(rawValue: viewModel.currentStep.rawValue - 1) {
                            viewModel.currentStep = prevStep
                        }
                    }
                                           .frame(width: 76)
                }
                
                Spacer()
                
                BakeRoadSolidButton(title: "다음",
                                    style: .primary,
                                    size: .large,
                                    isDisabled: !viewModel.canProceed) {
                    if let nextStep = OnboardingStep(rawValue: viewModel.currentStep.rawValue + 1) {
                        viewModel.currentStep = nextStep
                    } else {
                        print("닉네임 화면 이동")
                    }
                }
                                    .frame(width: 76)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }
}

struct StepIndicatorView: View {
    let currentStep: OnboardingStep
    
    var body: some View {
        let totalSteps = OnboardingStep.allCases.count
        
        HStack(spacing: 0) {
            ForEach(1...totalSteps, id: \.self) { step in
                HStack(spacing: 0) {
                    if step > 1 {
                        Rectangle()
                            .fill(Color.gray50)
                            .frame(width: 40, height: 4)
                            .padding(.horizontal, 3)
                    }
                    
                    ZStack {
                        if step < currentStep.rawValue {
                            Image("roundCheckbox")
                                .resizable()
                                .frame(width: 24, height: 24)
                        } else if step == currentStep.rawValue {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 24, height: 24)
                            Text("\(step)")
                                .foregroundColor(.white)
                                .font(.bodyXsmallSemibold)
                        } else {
                            Circle()
                                .fill(Color.gray50)
                                .frame(width: 24, height: 24)
                            Text("\(step)")
                                .foregroundColor(.gray300)
                                .font(.bodyXsmallSemibold)
                        }
                    }
                }
            }
        }
    }
}

struct PreferenceSelectionView: View {
    let step: OnboardingStep
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        let preferences = viewModel.allOptions[step] ?? []
        let selected = Set(viewModel.selections[step] ?? [])
        
        FlowLayout(items: preferences, spacing: 12) { pref in
            BakeRoadChip(
                title: pref.name,
                color: .main,
                size: .large,
                style: selected.contains(pref) ? .fill : .weak
            )
            .fixedSize()
            .onTapGesture {
                toggle(pref)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func toggle(_ preference: Preference) {
        var current = viewModel.selections[step] ?? []
        if current.contains(preference) {
            current.removeAll { $0 == preference }
        } else {
            current.append(preference)
        }
        viewModel.selections[step] = current
    }
}

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content
    
    @State private var totalHeight: CGFloat
    
    init(items: Data, spacing: CGFloat, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.items = items
        self.spacing = spacing
        self.content = content
        self._totalHeight = State(initialValue: .zero)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                self.content(item)
                    .padding(.horizontal, 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height + spacing
                        }
                        let result = width
                        if item == items.last {
                            width = 0
                        } else {
                            width -= d.width + spacing
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader())
    }
    
    private func viewHeightReader() -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.totalHeight = geometry.size.height
            }
            return Color.clear
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            viewModel: OnboardingViewModel(
                getPreferenceOptionsUseCase: MockGetPreferenceOptionsUseCase()
            )
        )
    }
}

final class MockGetPreferenceOptionsUseCase: GetPreferenceOptionsUseCase {
    func execute() async throws -> [OnboardingStep: [Preference]] {
        return [
            .breadType: [
                .init(id: 1, name: "페이스트리류 (크루아상, 뺑오쇼콜라)"),
                .init(id: 2, name: "담백한 식사용 빵 (식빵, 치아바타, 바게트, 하드롤)"),
                .init(id: 3, name: "건강한 빵 (비건, 글루텐프리, 저당)"),
                .init(id: 4, name: "구움과자류 (마들렌, 휘낭시에, 까눌레)"),
                .init(id: 5, name: "클래식 & 레트로 빵 (단팥빵, 맘모스, 꽈배기, 크림빵)"),
                .init(id: 6, name: "달콤한 디저트 빵 (마카롱, 타르트)"),
                .init(id: 7, name: "샌드위치 / 브런치 스타일"),
                .init(id: 8, name: "케이크, 브라우니, 파이류")
            ],
            .flavor: [
                .init(id: 9, name: "달달한게 최고!"),
                .init(id: 10, name: "버터 풍미 가득한 리치한 맛"),
                .init(id: 11, name: "짭짤한 빵 (치즈, 햄, 베이컨 등)"),
                .init(id: 12, name: "담백한 빵 (재료 본연의 맛)"),
                .init(id: 13, name: "단짠 조합"),
                .init(id: 14, name: "쫄깃하거나 꾸덕한 식감")
            ],
            .atmosphere: [
                .init(id: 15, name: "카페형 빵집 (커피와 함께 머물 수 있는 공간)"),
                .init(id: 16, name: "전통있는 오래된 빵집"),
                .init(id: 17, name: "SNS에서 핫한 곳"),
                .init(id: 18, name: "건강한 재료를 쓰는 수제 빵집"),
                .init(id: 19, name: "어디든 맛만 좋으면 OK")
            ]
        ]
    }
}
