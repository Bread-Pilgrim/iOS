//
//  WriteReviewView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/30/25.
//

import SwiftUI

struct WriteReviewView: View {
    @StateObject var viewModel: WriteReviewViewModel
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var authManager = PhotoAuthorizationManager()
    @State private var showPicker = false
    @State private var showPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView {
                BakeRoadTextButton(title: "이전", type: .assistive, size: .medium) {
                    dismiss()
                }
            } centerItem: {
                Text("리뷰 쓰기")
                    .font(.headingSmallBold)
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
            } rightItem: {
                HStack(spacing: 8) {
                    Toggle("", isOn: $viewModel.isPrivate)
                        .toggleStyle(SwitchToggleStyle(tint: Color.primary500))
                    
                    Text("나만보기")
                        .font(.bodySmallSemibold)
                        .foregroundColor(.gray800)
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 0) {
                    ReviewStarRatingView(rating: $viewModel.rating)
                        .padding(10)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(viewModel.selectedMenus.values)) { selectedMenu in
                                BakeRoadChip(title: selectedMenu.menu.name,
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
                                text: $viewModel.reviewContent)
                    .frame(height: 150)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    BakeRoadTextButton(title: "사진 추가하기",
                                       type: .primary,
                                       size: .medium,
                                       isDisabled: viewModel.selectedImages.count >= 5) {
                        AnyView(
                            Image(systemName: "plus")
                                .foregroundColor(viewModel.selectedImages.count >= 5 ? .gray200 : .primary500)
                                .frame(width: 20, height: 20)
                        )
                    } action: {
                        authManager.checkAuthorization()
                        if authManager.isAuthorized {
                            showPicker = true
                        } else {
                            showPermissionAlert = true
                        }
                    }
                    .fullScreenCover(isPresented: $showPicker) {
                        MultiPhotoPicker(selectedImages: $viewModel.selectedImages, maxSelectionCount: 5 - viewModel.selectedImages.count)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: viewModel.selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(12)
                                    
                                    Button(action: {
                                        viewModel.selectedImages.remove(at: index)
                                    }) {
                                        Image("circleClose")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    .padding(6)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            BakeRoadSolidButton(title: "작성 완료",
                                style: .primary,
                                size: .xlarge,
                                isDisabled: viewModel.reviewContent.count < 10) {
                viewModel.submitReview()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.2).ignoresSafeArea()
                ProgressView()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.errorMessage) { _, errorMessage in
            if let errorMessage = errorMessage {
                ToastManager.show(message: errorMessage, type: .error)
                viewModel.errorMessage = nil
            }
        }
        .alert("사진 접근 권한", isPresented: $showPermissionAlert) {
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("사진을 추가하려면 설정에서 사진 접근 권한을 허용해주세요.")
        }
    }
}

import Photos

final class PhotoAuthorizationManager: ObservableObject {
    @Published var isAuthorized: Bool = false

    init() {
        checkAuthorization()
    }

    func checkAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            isAuthorized = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    self.isAuthorized = (newStatus == .authorized || newStatus == .limited)
                }
            }
        default:
            isAuthorized = false
        }
    }
}
