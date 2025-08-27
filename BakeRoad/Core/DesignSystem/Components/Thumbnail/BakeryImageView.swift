//
//  BakeryImageView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/17/25.
//

import SwiftUI

import Kingfisher

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
            KFImage(URL(string: img))
                .placeholder {
                    Image(placeholder)
                        .resizable()
                }
                .resizable()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
        } else {
            Image(placeholder)
                .resizable()
        }
    }
}
