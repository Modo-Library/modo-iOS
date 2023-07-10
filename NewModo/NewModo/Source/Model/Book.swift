//
//  Library.swift
//  Modo
//
//  Created by MacBook on 2023/05/14.
//

import Foundation

struct Book : Identifiable {
    let idx: Int
    let id: String
    let lenderId: String
    let borrowerId: String?
    let name: String
    let author: String
    let imageURL: String
    var description: String
    var price: Int
    var genre: String?
    let createdAt: Date
    
    // 시간 차이로 나타내기
    var descriptionDate: String {
        let diff = Date().timeIntervalSince(createdAt)
        
        switch diff {
        case 0..<60:
            return "방금 전"
        case 60..<3600:
            return "\(Int(diff/60))분 전"
        case 3600..<86400: // 24시간 이전
            return "\(Int(diff/3600))시간 전"
        case 86400..<604800: // 이번주 내
            return "\(Int(diff/86400))일 전"
        case 604800..<2592000:
            return createdAt.getDay(format: "dd일")
        default:
            return createdAt.getDay(format: "MM월")
        }
    }
    
    static func getDummy()->[Self]{
        return [Book(idx: 0, id: UUID().uuidString, lenderId: "8772FB19-A882-4820-86CA-8F342A29D5AD", borrowerId: nil, name: "세이노의 가르침", author: "세이노", imageURL: "https://shopping-phinf.pstatic.net/main_3731353/37313533623.20230512071205.jpg?type=w300", description: "상태 A급 책입니다. 얼른 읽고 소감을 채팅으로 알려주세요! 상태 A급 책입니다. 얼른 읽고 소감을 채팅으로 알려주세요! 상태 A급 책입니다. 얼른 읽고 소감을 채팅으로 알려주세요! 상태 A급 책입니다. 얼른 읽고 소감을 채팅으로 알려주세요!", price: 500, createdAt: Date()),Book(idx: 1, id: UUID().uuidString, lenderId: "223E3986-5B0D-4C9D-8A3C-2DB4C60771DF", borrowerId: nil, name: "모든 삶은 흐른다", author: "로랑스 드빌레르, 이주영", imageURL: "https://comicthumb-phinf.pstatic.net/20230407_41/pocket_1680825669109g7EvF_JPEG/kyobo1324127389415304818l9791190299770.jpg?type=m260", description: "책 상태 깨끗합니다 편하게 빌려주세요~", price: 500, createdAt: Date(timeInterval: -608650, since: Date())),Book(idx: 2, id: UUID().uuidString, lenderId: "223E3986-5B0D-4C9D-8A3C-2DB4C60771DF", borrowerId: nil, name: "사피엔스", author: "유발 하라리", imageURL: "https://comicthumb-phinf.pstatic.net/20230128_278/pocket_167486043200855E9n_JPEG/kpc32124044933800342559788934972976.jpg?type=m260", description: "인공지능의 시대에 우리가 알아햘 것은 코딩보다 인간의 마음입니다. 어려운 책이지만 한번쯤 빌려보시는 것을 추천드립니다.", price: 1000, createdAt: Date(timeInterval: -10000, since: Date()))]
    }
    
    
}
