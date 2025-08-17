//
//  MenuSelectionView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/30/25.
//

import SwiftUI

struct MenuSelectionView: View {
    @StateObject var viewModel: WriteReviewViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView {
                Button {
                    dismiss()
                } label: {
                    Image("arrowLeft")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(16)
            } centerItem: {
                Text("메뉴 선택")
                    .font(.headingSmallBold)
                    .foregroundColor(.gray990)
                    .padding(.vertical, 15.5)
            } rightItem: {
                BakeRoadTextButton(title: "다음", type: .assistive, size: .medium, isDisabled: viewModel.selectedMenus.isEmpty) {
                    viewModel.navigateToWriteReview = true
                }
                .padding(.trailing, 16)
                .padding(.vertical, 13)
            }
            
            ScrollView(.vertical) {
                ForEach(viewModel.menus) { menu in
                    MenuRowView(
                        menu: menu,
                        selectedMenu: viewModel.selectedMenus[menu.id],
                        onToggle: { isSelected in
                            viewModel.toggleMenu(menu, isSelected: isSelected)
                        },
                        onQuantityChange: { quantity in
                            viewModel.updateMenuQuantity(menu.id, quantity: quantity)
                        }
                    )
                    .padding(.horizontal, 16)
                }
            }
            
            Spacer()
        }
        .navigationDestination(isPresented: $viewModel.navigateToWriteReview) {
            WriteReviewView(viewModel: viewModel)
        }
    }
}

struct MenuRowView: View {
    let menu: BakeryMenu
    let selectedMenu: SelectedMenu?
    let onToggle: (Bool) -> Void
    let onQuantityChange: (Int) -> Void
    
    var isSelected: Bool { selectedMenu != nil }
    var isCustomOption: Bool { menu.name == "여기에 없어요 😶" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if menu.isSignature {
                    BakeRoadChip(title: "대표메뉴", color: .sub, size: .small, style: .weak)
                        .padding(.trailing, 6)
                }
                
                Text(menu.name)
                    .font(.bodySmallMedium)
                    .foregroundColor(isSelected ? .white : .gray990)
                
                Spacer()
                
                Image("circleCheck")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray100)
            }
            
            if isSelected && !isCustomOption {
                HStack {
                    Text("구매 수량을 선택해주세요.")
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    QuantitySelector(
                        quantity: selectedMenu?.quantity ?? 1,
                        onChange: { onQuantityChange($0) }
                    )
                }
            }
        }
        .padding()
        .background(isSelected ? Color.positive500 : Color.gray40)
        .cornerRadius(12)
        .onTapGesture {
            onToggle(!isSelected)
        }
    }
}

struct QuantitySelector: View {
    var quantity: Int
    var onChange: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                if quantity > 1 {
                    onChange(quantity - 1)
                }
            } label: {
                Image(systemName: "minus")
                    .foregroundColor(quantity > 1 ? .black : .gray200)
                    .frame(width: 20, height: 20)
            }
            .disabled(quantity <= 1)
            
            Text("\(quantity)")
                .font(.bodySmallMedium)
                .frame(width: 24, height: 21)
                .padding(.vertical, 8)
            
            Button {
                if quantity < 99 {
                    onChange(quantity + 1)
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(quantity < 99 ? .black : .gray200)
                    .frame(width: 20, height: 20)
            }
            .disabled(quantity > 99)
        }
        .padding(.horizontal, 8)
        .background(Color.white)
        .cornerRadius(6)
    }
}
