//
//  EX+View.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//
import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    // MARK: - 다른 화면 터치 시 키보드가 내려감
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    // MARK: - 커스텀 네비게이션 링크
    func customNavLink(to destination : some View, title: String?) -> some View {
        NavigationLink(destination: destination) {
            RoundedRectangle(cornerRadius: 4)
                .frame(height: Screen.maxHeight*0.06)
                .foregroundColor(Color("Brown0"))
                .overlay {
                    Text(title != nil ? title! : "확인" )
                        .foregroundColor(.white)
                        .font(.pretendardHeadline)
                }
        }
    }
    
    // MARK: - 기본 네비게이션 링크
    func actionNavLink(to destination : some View, title: String?) -> some View {
        
        NavigationLink(destination: destination) {
            RoundedRectangle(cornerRadius: 17)
                .frame(width:Screen.maxWidth*0.24,height: Screen.maxWidth*0.08)
                .foregroundColor(Color("Brown1"))
                .overlay {
                    Text(title != nil ? title! : "확인" )
                        .foregroundColor(.white)
                        .font(.pretendardHeadline)
                }
        }
    }
    
}
