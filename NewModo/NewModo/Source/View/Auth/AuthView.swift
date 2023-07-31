//
//  AuthView.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

// AuthView -> SignInView -> ContentView
//                  ㄴ-> SignUpView -> PhoneAuthview -> MapAuthView -> SignUpDetailView -> ContentView

import SwiftUI

enum AuthState {
    case launchScreen
    case signIn
    case authenticating //로그인중
    case authenticated
}

struct AuthView: View {
    @State private var authState : AuthState = .launchScreen
    @State private var isShowing = false
    @State private var isAuthenticated = false
    
    var body: some View {
        switch authState {
        case .launchScreen:
            ZStack(alignment: .center) {
                Color("Brown3").edgesIgnoringSafeArea(.all).zIndex(0)
                if isShowing {
                    Image("LaunchIcon").transition(.opacity).zIndex(1)
                    
                    .onAppear {
                        // 특정 코드를 일정 시간 뒤에 실행시키고자 하는 경우!
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            withAnimation {
                                authState = isAuthenticated ? .authenticated : .signIn
                            }
                        })
                    }
                }
            }
            .onAppear {
                let userToken = UserViewModel.shared.getTokenFromUserDefaults()
                if let userToken {
                    Task{
                        await UserViewModel.shared.findUserWithTestUserID(accessToken: userToken.accessToken)
                        if UserViewModel.shared.isAccessTokenExpired {
                            // accessToken 만료 -> 리프레쉬 토큰으로 reissue
                            await UserViewModel.shared.reissueAuthWithRefreshToken(userToken.refreshToken)
                            if UserViewModel.shared.isReissueFailed {
                                isAuthenticated = true
                            }
                            
                        }else{
                            isAuthenticated = true
                        }
                    }
                }
                
                // 특정 코드를 일정 시간 뒤에 실행시키고자 하는 경우!
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                    withAnimation {
                        isShowing.toggle()
                    }
                })
            }
        case .signIn, .authenticating:
            NavigationView{
                SignInView(authState: $authState)
            }
        case .authenticated :
                ContentView()
        }
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
