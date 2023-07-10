//
//  NaverBookSearchDTO.swift
//  Modo
//
//  Created by MacBook on 2023/05/23.
//

import Foundation

struct NaverBookSearch: Codable,Hashable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [BookInfo]
}

struct BookInfo: Codable,Hashable {
    let title: String
    let link: String
    let image: String
    let author: String
    let discount: String
    let publisher: String
    let pubdate: String
    let isbn: String
    let description: String
}
