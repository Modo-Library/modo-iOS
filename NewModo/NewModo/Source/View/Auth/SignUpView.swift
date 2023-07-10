//
//  SignUpView.swift
//  Modo
//
//  Created by MacBook on 2023/05/13.
//

import SwiftUI

struct SignUpView: View {
    @State var signUpState : SignUpState = .phone
    
    var body: some View {
        Group{
            switch signUpState {
            case .phone:
                PhoneAuthView(signUpState: $signUpState)
            case .map:
                MapAuthView(signUpState: $signUpState)
            case .detail:
                SignUpDetailView(signUpState: $signUpState)
            case .complete:
                SignUpCompleteView(signUpState: $signUpState)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
