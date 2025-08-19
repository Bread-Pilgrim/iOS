//
//  BakeRoadToast.swift
//  BakeRoad
//
//  Created by 이현호 on 7/6/25.
//

import SwiftUI

enum ToastType {
    case success
    case error

    var icon: Image {
        switch self {
        case .success: return Image(systemName: "checkmark.circle.fill")
        case .error: return Image(systemName: "exclamationmark.circle.fill")
        }
    }

    var iconColor: Color {
        switch self {
        case .success: return .primary500
        case .error: return .error500
        }
    }
}

enum ToastStyle {
    case dark
    case light

    var backgroundColor: Color {
        switch self {
        case .dark: return .black
        case .light: return .white
        }
    }

    var textColor: Color {
        switch self {
        case .dark: return .white
        case .light: return .black
        }
    }
}

struct ToastView: View {
    let message: String
    let type: ToastType
    let style: ToastStyle

    var body: some View {
        HStack(spacing: 8) {
            type.icon
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(type.iconColor)

            Text(message)
                .font(.bodyXsmallMedium)
                .foregroundColor(style.textColor)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(style.backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
    }
}

class ToastManager: ObservableObject {
    @Published var toast: ToastData?

    private var dismissWorkItem: DispatchWorkItem?
    
    static let shared = ToastManager()

    func show(message: String, type: ToastType = .success, style: ToastStyle = .dark, duration: TimeInterval = 2.0) {
        dismissWorkItem?.cancel()

        toast = ToastData(message: message, type: type, style: style)

        let task = DispatchWorkItem { [weak self] in
            withAnimation {
                self?.toast = nil
            }
        }

        dismissWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    static func show(message: String, type: ToastType = .success, style: ToastStyle = .dark, duration: TimeInterval = 2.0) {
        shared.show(message: message, type: type, style: style, duration: duration)
    }
}

struct ToastData: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
    let style: ToastStyle
}

struct ToastOverlayView: View {
    @EnvironmentObject var toastManager: ToastManager

    @State private var isVisible: Bool = false

    var body: some View {
        ZStack {
            if toastManager.toast != nil {
                VStack {
                    Spacer()
                    ToastView(message: toastManager.toast!.message, type: toastManager.toast!.type, style: toastManager.toast!.style)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 20) // 아래에서 올라옴
                        .animation(.easeOut(duration: 0.25), value: isVisible)
                        .onAppear {
                            isVisible = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                withAnimation(.easeIn(duration: 0.25)) {
                                    isVisible = false
                                }
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.3), value: toastManager.toast)
    }
}
