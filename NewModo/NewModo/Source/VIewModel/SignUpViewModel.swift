//
//  AuthViewModl.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

import SwiftUI

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var pw: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var latitude: CGFloat = 0
    @Published var longitude: CGFloat = 0
    @Published var region: String = ""
    
    @Published var isDuplicated = false
    
//    func checkEmailDuplicated() {
//        AuthManager().checkEmailDuplicated(email) { result in
//            switch result {
//            case .success(let check) :
//                DispatchQueue.main.async {
//                    print("성공 \(check)")
//                    self.isDuplicated = check
//                }
//            case .failure(let error) :
//                print("Network Error : \(error)")
//            }
//        }
//    }
    
}

