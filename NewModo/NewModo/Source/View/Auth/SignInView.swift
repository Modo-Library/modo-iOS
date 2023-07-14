//
//  SignInView.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct SignInView: View {
    @EnvironmentObject var authVM : AuthViewModel
    @Binding var authState : AuthState
    @State private var isLoggedIn : Bool = false
    
    var body: some View {
        VStack{
            //로고 이미지
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:70)
                HStack{
                    Text("모두의")
                        .foregroundColor(Color("Brown0"))
                        .font(.pretendardLargeTitle)
                        .bold()
                    Text("도서관")
                        .foregroundColor(.black)
                        .font(.pretendardLargeTitle)
                        .bold()
                }
            }
            .padding([.top,.bottom],Screen.maxHeight*0.05)
            
            Spacer()
            
            VStack(spacing: 18) {
                //카카오 로그인 버튼
                Button {
                    authVM.kakaoLogin()
                    //kakaoAuthVM.handleKaKaoLogin()
                } label: {
                    Image("kakaologin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 320)
                }
                
                //구글 로그인 버튼
                //GoogleSignInButton(action: googleAuthVM.signIn)
                Button {
                    authVM.googleSignIn()
                } label: {
                    Image("googlelogin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 320)
                }
                
                //애플 로그인 버튼
                HStack {
                    Image(systemName: "applelogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)


                    Text("Apple Sign in")
                        .font(.callout)
                        .lineLimit(1)
                }
                .foregroundColor(.white)
                .padding(.horizontal,15)
                .frame(width: 320, height: 50, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black)
                }
                .overlay {
                    SignInWithAppleButton { request in
                        authVM.nonce = randomNonceString()
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(authVM.nonce)

                    } onCompletion: { (result) in
                        switch result {
                        case .success(let user):
                            print("success")
                            guard let credential = user.credential as?
                                    ASAuthorizationAppleIDCredential else {
                                print("error with firebase")
                                return
                            }
                            Task { await authVM.appleAuthenticate(credential: credential) }
                        case.failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .signInWithAppleButtonStyle(.white)
                    .cornerRadius(8)
                    .frame(height: 45)
                    .blendMode(.overlay)
                }
                .clipped()
//                AppleSigninButton()
                
                Button {
                    authState = .authenticated
                    authVM.loginState = .pass
                } label: {
                    Text("로그인 건너뛰기")
                        .foregroundColor(.secondary)
                        .font(.pretendardHeadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // <-
            .onTapGesture { // <-
                endTextEditing()
            }
        
        
    }
}

struct AppleSigninButton : View{
    var body: some View{
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential{
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                           // 계정 정보 가져오기
                            let UserIdentifier = appleIDCredential.user
                            let fullName = appleIDCredential.fullName
                            let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                            let email = appleIDCredential.email
                            let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                            let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(width : UIScreen.main.bounds.width * 0.9, height:50)
        .cornerRadius(5)
    }
}

struct SignInView_Previews: PreviewProvider {
    @State static var authState : AuthState = .signIn
    static var previews: some View {
        NavigationView{
            SignInView(authState: $authState)
        }
    }
}
