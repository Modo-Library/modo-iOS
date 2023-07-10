//
//  NaverBookSearchRouter.swift
//  Modo
//
//  Created by MacBook on 2023/05/23.
//

import Foundation

enum NaverBookSearchRouter {
    
    case get
    private enum HTTPMethod {
        case get
        
        var value: String {
            switch self {
            case .get: return "GET"
            }
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        }
    }
    func asURLRequest(bookName: String) throws -> URLRequest {
        // requestAddress -> 주소 검색할 String 값 받아야 합니다
        let queryURL = "https://openapi.naver.com/v1/search/book.json?query=\(bookName)"
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        
        //네이버  인증키 필요
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("fvu7yTs6clJEUYXlvXrN", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("uJVfh2EdhP", forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpMethod = method.value
        return request
    }
}
