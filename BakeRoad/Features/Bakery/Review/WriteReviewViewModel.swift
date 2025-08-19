//
//  WriteReviewViewModel.swift
//  BakeRoad
//
//  Created by 이현호 on 8/17/25.
//

import Foundation
import SwiftUI

struct SelectedMenu: Identifiable {
    let id: Int
    let menu: BakeryMenu
    var quantity: Int
}

@MainActor
final class WriteReviewViewModel: ObservableObject {
    @Published var menus: [BakeryMenu] = []
    @Published var selectedMenus: [Int: SelectedMenu] = [:]
    @Published var navigateToWriteReview = false
    @Published var errorMessage: String?
    @Published var rating: Double = 2.5
    @Published var reviewContent: String = ""
    @Published var isPrivate: Bool = true
    @Published var selectedImages: [UIImage] = []
    @Published var isLoading = false
    
    private let bakeryId: Int
    private let getBakeryMenuUseCase: GetBakeryMenuUseCase
    private let writeReviewUseCase: WriteReviewUseCase
    
    var onReviewSubmitted: (() -> Void)?
    
    init(
        bakeryId: Int,
        getBakeryMenuUseCase: GetBakeryMenuUseCase,
        writeReviewUseCase: WriteReviewUseCase
    ) {
        self.bakeryId = bakeryId
        self.getBakeryMenuUseCase = getBakeryMenuUseCase
        self.writeReviewUseCase = writeReviewUseCase
        Task { await loadInitial() }
    }
    
    private func loadInitial() async {
        async let bakeryMenus = getBakeryMenus(bakeryId)
        menus = await bakeryMenus
    }
    
    private func getBakeryMenus(_ id: Int) async -> [BakeryMenu] {
        do {
            return try await getBakeryMenuUseCase.execute(bakeryId)
        } catch let APIError.serverError(_, message) {
            errorMessage = message
        } catch {
            errorMessage = "잠시 후 다시 시도해주세요."
        }
        return []
    }
    
    func toggleMenu(_ menu: BakeryMenu, isSelected: Bool) {
        if isSelected {
            selectedMenus[menu.id] = SelectedMenu(id: menu.id, menu: menu, quantity: 1)
        } else {
            selectedMenus.removeValue(forKey: menu.id)
        }
    }
    
    func updateMenuQuantity(_ menuId: Int, quantity: Int) {
        selectedMenus[menuId]?.quantity = quantity
    }
    
    func proceedToWriteReview() {
        guard !selectedMenus.isEmpty else { return }
        navigateToWriteReview = true
    }
    
    func submitReview() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                // SelectedMenu를 ConsumedMenu로 변환
                let consumedMenus = selectedMenus.values.map { selectedMenu in
                    ConsumedMenu(menuId: selectedMenu.menu.id, quantity: selectedMenu.quantity)
                }
                
                // 이미지를 Data로 변환
                let imageData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                
                // 리뷰 작성 API 호출
                try await writeReviewUseCase.execute(
                    bakeryId,
                    request: WriteReviewRequestDTO(
                        rating: rating,
                        content: reviewContent,
                        isPrivate: isPrivate,
                        menus: consumedMenus,
                        imageUrls: nil
                    ),
                    imageData: imageData
                )
                
                onReviewSubmitted?()
            } catch let APIError.serverError(_, message) {
                errorMessage = message
            } catch {
                errorMessage = "리뷰 작성에 실패했습니다. 잠시 후 다시 시도해주세요."
            }
            
            isLoading = false
        }
    }
}
