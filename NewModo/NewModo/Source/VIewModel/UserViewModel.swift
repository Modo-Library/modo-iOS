//
//  UserViewModel.swift
//  NewModo
//
//  Created by MacBook on 2023/07/31.
//

import Foundation
import Alamofire



class UserViewModel : ObservableObject {
    static var shared = UserViewModel()
    
    @Published var isAccessTokenExpired: Bool = true
    @Published var isReissueFailed: Bool = true
    @Published var token: UserToken = UserToken(accessToken: "", refreshToken: "",usersId: "")
    //@Published var user: User = User(userId: "", userName: "")
    
    // 토큰을 저장할 UserDefaults 키
    let refreshTokenKey = "refreshToken"
    let accessTokenKey = "accessToken"
    let usersIdKey = "usersId"

    // 토큰을 UserDefaults에 저장하는 함수
    func saveTokenToUserDefaults(_ token: UserToken) {
        UserDefaults.standard.set(token.accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(token.refreshToken, forKey: refreshTokenKey)
        UserDefaults.standard.set(token.usersId, forKey: usersIdKey)
    }

    // UserDefaults에서 토큰을 가져오는 함수
    func getTokenFromUserDefaults() -> UserToken? {
        let accessToken = UserDefaults.standard.string(forKey: accessTokenKey)
        let refreshToken = UserDefaults.standard.string(forKey: refreshTokenKey)
        let usersId = UserDefaults.standard.string(forKey: usersIdKey)
        
        if let accessToken, let refreshToken, let usersId {
            return UserToken(accessToken: accessToken, refreshToken: refreshToken, usersId: usersId)
        }
        return nil
    }

    // 토큰을 삭제하는 함수
    func removeTokenFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: usersIdKey)
    }
    
    
    // 리프레쉬토큰으로 토큰을 재발급하는 함수
    func reissueAuthWithRefreshToken(_ refreshToken: String) async{
        let url = "https://modolib.com/api/v1/auth/reIssue"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": refreshToken
        ]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: UserToken.self) { response in
                switch response.result {
                case .success(let userToken):
                    // 디코딩 성공: userToken 객체에 디코딩된 데이터가 저장됩니다.
                    print("User Token: \(userToken)")
                    UserViewModel.shared.isReissueFailed = false
                    // UserDefaults에 토큰 저장
                    UserViewModel.shared.saveTokenToUserDefaults(userToken)
                    
                case .failure(let error):
                    // 디코딩 에러 또는 네트워크 에러 처리
                    if let responseData = response.data,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: responseData) {
                        // 에러 데이터를 디코딩하여 사용할 수 있는 형태로 파싱합니다.
                        print("Error Message: \(errorResponse.message)")
                        print("Error Code: \(errorResponse.errorCode)")
                        print("Error Name: \(errorResponse.name)")
                    } else {
                        // 에러 데이터 디코딩 실패 또는 다른 네트워크 에러 처리
                        print("Error: \(error)")
                    }
                }
            }
        
        
    }

    func findUserWithTestUserID(accessToken: String) async{
        
        let url = "https://modolib.com/api/v1/users/findUsers/testUsersId"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": accessToken
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: UserResponseDTO.self) { response in
                switch response.result {
                case .success(let userResponse):
                    // 디코딩 성공: userResponseDTO 객체에 디코딩된 데이터가 저장됩니다.
                    print("User Response: \(userResponse)")
                    self.isAccessTokenExpired = false
                case .failure(let error):
                    // 디코딩 에러 또는 네트워크 에러 처리
                    if let responseData = response.data,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: responseData) {
                        // 에러 데이터를 디코딩하여 사용할 수 있는 형태로 파싱합니다.
                        print("Error Message: \(errorResponse.message)")
                        print("Error Code: \(errorResponse.errorCode)")
                        print("Error Name: \(errorResponse.name)")
                    } else {
                        // 에러 데이터 디코딩 실패 또는 다른 네트워크 에러 처리
                        print("Error: \(error)")
                    }
                }
            }
    }

    
    
}
