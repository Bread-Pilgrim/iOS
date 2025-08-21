//
//  OnboardingView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    var onFinish: () -> Void
    @State private var showDismissAlert = false
    @Environment(\.dismiss) private var dismiss
    
    init(
        viewModel: OnboardingViewModel,
        onFinish: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onFinish = onFinish
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    showDismissAlert = true
                } label: {
                    Image("arrowLeft")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .opacity(viewModel.isPreferenceEdit && viewModel.currentStep == OnboardingStep.allCases.first ? 1 : 0)
                
                Spacer()
            }
            .padding(16)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.currentStep.titleText)
                    .font(.headingLargeBold)
                    .foregroundColor(.black)
                Text(viewModel.currentStep.subtitleText)
                    .font(.bodySmallRegular)
                    .foregroundColor(.gray800)
            }
            .padding(.top, 11)
            .padding(.leading, 16)
            
            StepIndicatorView(currentStep: viewModel.currentStep)
                .padding(.top, 25)
                .padding(.leading, 16)
            
            if viewModel.allOptions[viewModel.currentStep]?.isEmpty ?? true {
                SkeletonPreferenceView(step: viewModel.currentStep)
            } else {
                PreferenceSelectionView(step: viewModel.currentStep,
                                        viewModel: viewModel)
                .padding(.top, 42)
            }
            
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
                
                BakeRoadSolidButton(title: viewModel.isPreferenceEdit && viewModel.currentStep == OnboardingStep.allCases.last ? "저장" : "다음",
                                    style: .primary,
                                    size: .large,
                                    isDisabled: !viewModel.canProceed) {
                    if viewModel.isPreferenceEdit && viewModel.currentStep == OnboardingStep.allCases.last {
                        Task {
                            await viewModel.updatePreferences()
                            onFinish()
                        }
                    } else if let nextStep = OnboardingStep(rawValue: viewModel.currentStep.rawValue + 1) {
                        viewModel.currentStep = nextStep
                    } else {
                        onFinish()
                    }
                }
                                    .frame(width: 76)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let message = newValue {
                ToastManager.show(message: message, type: .error)
                viewModel.errorMessage = nil
            }
        }
        .overlay {
            if showDismissAlert {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .overlay {
                        BakeRoadAlert(
                            title: "취향을 저장하지 않고 나가시나요?",
                            message: "변경한 취향은 모두 저장되지 않아요😂",
                            primaryAction: AlertAction(title: "나가기") {
                                showDismissAlert = false
                                dismiss()
                            },
                            secondaryAction: AlertAction(title: "취소") {
                                showDismissAlert = false
                            },
                            layout: .horizontal
                        )
                    }
            }
        }
        .overlay {
            ToastOverlayView()
                .environmentObject(ToastManager.shared)
                .padding(.horizontal, 28)
                .padding(.bottom, 16)
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
