//
//  BtnModifier.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

import SwiftUI


struct ConfirmBtnModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: Screen.maxHeight*0.1)
            .foregroundColor(Color("Brown0"))
    }
}


struct tfCheckMarkModifier : ViewModifier {
    func body(content: Content) -> some View {
        
    }
}

struct BasicBrownButton: ButtonStyle {
    var buttonColor: Color = Color("Brown0")
    var buttonTextColor: Color = .white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(buttonColor)
            .frame(height: 55)
            .overlay {
                configuration.label
                    .foregroundColor(buttonTextColor)
                    .font(.pretendardTitle3)
                    .foregroundColor(buttonColor)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ActionBrownButton: ButtonStyle {
    var buttonColor: Color = Color("Brown1")
    var buttonTextColor: Color = .white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        RoundedRectangle(cornerRadius: 17)
            .foregroundColor(buttonColor)
            .frame(width:Screen.maxWidth*0.24,height: Screen.maxWidth*0.08)
            .overlay {
                configuration.label
                    .foregroundColor(buttonTextColor)
                    .font(.pretendardHeadline)
                    .foregroundColor(buttonColor)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
    
    
}
