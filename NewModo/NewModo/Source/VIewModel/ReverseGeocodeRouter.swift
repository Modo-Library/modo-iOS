//
//  ReverseGeocodeRouter.swift
//  Modo
//
//  Created by MacBook on 2023/05/08.
//

import Foundation

enum ReverseGeocodeRouter {
    
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
    func asURLRequest(latitude: Double, longitude: Double) throws -> URLRequest {
        // requestAddress -> 주소 검색할 String 값 받아야 합니다
        let queryURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(longitude),\(latitude)&sourcecrs=epsg:4326&orders=addr&output=json"
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //NaverAPIEnum.naverApI.clientID
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        
        //네이버 클라우드 플랫폼 인증키 필요
        request.setValue(NMF_CLIENT_ID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.setValue(NMF_SECRET_CLIENT, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.httpMethod = method.value
        return request
    }
}
