//
//  User.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

import Foundation

struct User: Identifiable {
    let idx: Int
    let id: String
    var Grade: String //등급
    var phoneNumber: Int
    var deviceToken: String
    var address: String
    var name: String // 도서관이름
    var longitude: Double
    var latitude: Double
    var power: Int //지식의힘
    //var wish:
    
    static func getDummy()->[Self] {
        return [User(idx: 0, id: "8772FB19-A882-4820-86CA-8F342A29D5AD", Grade: "도서킹", phoneNumber: 01012345678, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "차원의 도서관", longitude: 127.043668, latitude: 37.280269, power: 500),User(idx: 1, id: "223E3986-5B0D-4C9D-8A3C-2DB4C60771DF", Grade: "도서퀸", phoneNumber: 01012345677, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "아주대 도서관", longitude: 127.043669, latitude: 37.280267, power: 400),
                User(idx: 0, id: "8772FB19-A882-4820-86CA-8F342A29D5AD", Grade: "도서킹", phoneNumber: 01012345678, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "차원의 도서관", longitude: 127.042790, latitude: 37.282440, power: 500),
                User(idx: 0, id: "8772FB19-A882-4820-86CA-8F342A29D5AD", Grade: "도서킹", phoneNumber: 01012345678, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "차원의 도서관", longitude: 127.044935, latitude: 37.281945, power: 500),
                User(idx: 0, id: "8772FB19-A882-4820-86CA-8F342A29D5AD", Grade: "도서킹", phoneNumber: 01012345678, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "차원의 도서관", longitude: 127.044914, latitude: 37.279026, power: 500),
                User(idx: 0, id: "8772FB19-A882-4820-86CA-8F342A29D5AD", Grade: "도서킹", phoneNumber: 01012345678, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "차원의 도서관", longitude: 127.042468, latitude: 37.279162, power: 500),
                User(idx: 0, id: "8772FB19-A882-4820-86CA-8F342A29D5AD", Grade: "도서킹", phoneNumber: 01012345678, deviceToken: "x", address: "경기도 수원시 우만동 51-2", name: "차원의 도서관", longitude: 37.278957, latitude: 127.043412, power: 500)]
    }
    //37.282440 127.042790
    //37.281945 127.044935
    //37.279026 127.044914
    //37.279162 127.042468
    //37.278957 127.043412
    
}
