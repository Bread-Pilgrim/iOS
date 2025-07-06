//
//  ContentView.swift
//  BakeRoad
//
//  Created by 이현호 on 6/5/25.
//

import SwiftUI

import KakaoSDKUser

struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
}

#Preview {
    SheetView()
}

struct SheetView: View {
    @State private var showSheet = false
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        ToastOverlayView().environmentObject(toastManager)
        VStack {
            Button("시트 띄우기") {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                BakeRoadSheet(
                    title: "알림",
                    message: "이것은 커스텀 시트입니다.",
                    primaryAction: SheetAction(title: "확인", action: {
                        showSheet = false
                    }),
                    secondaryAction: SheetAction(title: "취소", action: {
                        showSheet = false
                    })
                ) {
                    VStack(spacing: 16) {
                        Text("이건 내부 콘텐츠입니다")
                        Text("높이는 자동으로 측정됩니다")
                    }
                }
                .presentationDetents([.fraction(0.4)])
            }
            
            Button("성공 토스트 보여주기") {
                toastManager.show(message: "성공적으로 저장되었습니다!", type: .success, style: .dark)
            }
        }
    }
}



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
        case .success: return .green
        case .error: return .red
        }
    }

    var textColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        }
    }
}

enum ToastStyle {
    case dark
    case light

    var backgroundColor: Color {
        switch self {
        case .dark: return .black
        case .light: return Color(red: 1.0, green: 0.98, blue: 0.98)
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
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(style == .dark ? .white : type.textColor)
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(style.backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(maxWidth: 300)
    }
}



import SwiftUI

class ToastManager: ObservableObject {
    @Published var toast: ToastData?

    private var dismissWorkItem: DispatchWorkItem?

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
}

struct ToastData: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
    let style: ToastStyle
}



import SwiftUI

struct ToastOverlayView: View {
    @EnvironmentObject var toastManager: ToastManager

    @State private var isVisible: Bool = false

    var body: some View {
        ZStack {
            if toastManager.toast != nil {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.3), value: toastManager.toast)
    }
}
