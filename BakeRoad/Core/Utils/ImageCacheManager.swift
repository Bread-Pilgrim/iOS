//
//  ImageCacheManager.swift
//  BakeRoad
//
//  Created by 이현호 on 8/19/25.
//

import SwiftUI
import Foundation

@MainActor
final class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private init() {
        // 메모리 캐시 설정
        memoryCache.countLimit = 100 // 최대 100개 이미지
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    
    // 이미지 가져오기 (메모리 → 네트워크 순서)
    func getImage(from urlString: String, maxSize: CGSize? = nil) async -> UIImage? {
        let key = NSString(string: urlString)
        
        // 1. 메모리 캐시에서 확인
        if let cachedImage = memoryCache.object(forKey: key) {
            return cachedImage
        }
        
        // 2. 네트워크에서 다운로드
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            let finalImage = resizeIfNeeded(image, maxSize: maxSize)
            
            // 메모리 캐시에 저장
            memoryCache.setObject(finalImage, forKey: key)
            
            return finalImage
        } catch {
            return nil
        }
    }
    
    private func resizeIfNeeded(_ image: UIImage, maxSize: CGSize?) -> UIImage {
        guard let maxSize = maxSize else { return image }
        
        let currentSize = image.size
        if currentSize.width <= maxSize.width && currentSize.height <= maxSize.height {
            return image
        }
        
        let widthRatio = maxSize.width / currentSize.width
        let heightRatio = maxSize.height / currentSize.height
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: currentSize.width * ratio, height: currentSize.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
    
    // 캐시 정리
    func clearCache() {
        memoryCache.removeAllObjects()
    }
}