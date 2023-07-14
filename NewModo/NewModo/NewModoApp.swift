//
//  NewModoApp.swift
//  NewModo
//
//  Created by MacBook on 2023/07/10.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

@main
struct NewModoApp: App {
    @StateObject var authVM : AuthViewModel = AuthViewModel()
    
    init() {
        // Kakao SDK 초기화
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(authVM)
            
                .onOpenURL { url in
                    //카카오
                    if (AuthApi.isKakaoTalkLoginUrl(url)){
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    
                    // 구글
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                    }
                }
        }
    }
}
