//
//  CachedAsyncImage.swift
//  BakeRoad
//
//  Created by 이현호 on 8/19/25.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let urlString: String
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    init(
        url: String,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.urlString = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                // 로딩 실패 시 placeholder 표시
                placeholder()
            }
        }
        .task(id: urlString) {
            await loadImage()
        }
        .onChange(of: urlString) { oldValue, newValue in
            if oldValue != newValue {
                image = nil
                isLoading = true
            }
        }
    }
    
    @MainActor
    private func loadImage() async {
        isLoading = true
        
        if let cachedImage = await ImageCacheManager.shared.getImage(from: urlString) {
            image = cachedImage
        }
        
        isLoading = false
    }
}

// 편의 생성자들
extension CachedAsyncImage where Content == Image, Placeholder == ProgressView<EmptyView, EmptyView> {
    init(url: String) {
        self.init(url: url) { image in
            image
        } placeholder: {
            ProgressView()
        }
    }
}

extension CachedAsyncImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(
        url: String,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.init(url: url, content: content) {
            ProgressView()
        }
    }
}
