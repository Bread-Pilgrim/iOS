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
