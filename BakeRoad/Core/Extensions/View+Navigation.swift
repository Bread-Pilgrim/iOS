//
//  View+Navigation.swift
//  BakeRoad
//
//  Created by Claude on 8/25/25.
//

import SwiftUI

extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .automatic)
    }
}