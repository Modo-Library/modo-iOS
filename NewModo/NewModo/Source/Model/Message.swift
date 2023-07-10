//
//  Message.swift
//  Modo
//
//  Created by MacBook on 2023/05/18.
//

import Foundation

struct Message: Identifiable,Equatable,Hashable {
    let id: String
    let sender: String
    let text: String
    let date: Date
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    var yyyymmdd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
}
