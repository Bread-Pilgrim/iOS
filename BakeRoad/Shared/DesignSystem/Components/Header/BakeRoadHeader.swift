//
//  BakeRoadHeader.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import SwiftUI

struct HeaderView<Left: View, Center: View, Right: View>: View {
    let leftItem: Left
    let centerItem: Center
    let rightItem: Right
    
    init(
        @ViewBuilder leftItem: () -> Left = { EmptyView() },
        @ViewBuilder centerItem: () -> Center = { EmptyView() },
        @ViewBuilder rightItem: () -> Right = { EmptyView() }
    ) {
        self.leftItem = leftItem()
        self.centerItem = centerItem()
        self.rightItem = rightItem()
    }
    
    var body: some View {
        HStack {
            leftItem
            Spacer()
            centerItem
            Spacer()
            rightItem
        }
        .padding()
        .background(Color.white)
    }
}
