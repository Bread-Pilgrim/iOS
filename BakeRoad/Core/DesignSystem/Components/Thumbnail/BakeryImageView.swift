//
//  BakeryImageView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/17/25.
//

import SwiftUI

enum ThumbnailRatio: String {
    case ratio1_1, ratio5_4, ratio4_3, ratio3_2, ratio16_10, ratio16_9, ratio2_1, ratio21_9
}

struct BakeryImageView: View {
    let imageUrl: String?
    let placeholder: String
    
    init(imageUrl: String?,
         placeholder: ThumbnailRatio) {
        self.imageUrl = imageUrl
        self.placeholder = placeholder.rawValue
    }
    
    var body: some View {
        if let img = imageUrl {
            CachedAsyncImage(url: img) { image in
                image
                    .resizable()
            } placeholder: {
                Image(placeholder)
                    .resizable()
            }
        } else {
            Image(placeholder)
                .resizable()
        }
    }
}
