//
//  NaverBookSearchService.swift
//  Modo
//
//  Created by MacBook on 2023/05/23.
//

import Foundation
import Combine

enum NaverBookSearchService {
    
    static func getNaverBookSearch(bookName: String) -> AnyPublisher<NaverBookSearch, Error> {
        // query 책제목,내용,저자 기타등등 모두 검색
        let queryURL = "https://openapi.naver.com/v1/search/book.json?query=\(bookName)"
        print("getNaverBookSearch gueryName: \(bookName)")
        //MARK: URL의 string:은 영문, 숫자와 특정 문자만 인식 가능하며, 한글, 띄어쓰기 등은 인식하지 못합니다.!!
        // 분명 한글로 요청이 올테니 인코딩
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        do {
            request = try NaverBookSearchRouter.get.asURLRequest(bookName: bookName)
        } catch {
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{
                $0.data
            }
            .decode(type: NaverBookSearch.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
