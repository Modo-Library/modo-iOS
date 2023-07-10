//
//  SignUpCompleteView.swift
//  Modo
//
//  Created by MacBook on 2023/05/10.
//

import SwiftUI

struct SignUpCompleteView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var signUpState : SignUpState
    
    
    var body: some View {
        VStack{
            Image("saly")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth*0.8)
            Text("축하합니다!")
                .font(.pretendardTitleBold)
            Group{
                Text("이제 모두의 도서관 서비스를")
                    .padding(.top,10)
                Text("이용하실 수 있습니다.")
            }
            .font(.pretendardCallout)
            
            Button(action: {
                dismiss()
            }) {
                Text("홈으로")
            }
            .buttonStyle(BasicBrownButton())
            .padding(.top,50)
        }
        .padding(30)
    }
}

struct SignUpCompleteView_Previews: PreviewProvider {
    @State static var signUpState : SignUpState = .complete
    
    static var previews: some View {
        SignUpCompleteView(signUpState: $signUpState)
    }
}
