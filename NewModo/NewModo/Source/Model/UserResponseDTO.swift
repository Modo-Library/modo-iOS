//
//  UserResponseDTO.swift
//  NewModo
//
//  Created by MacBook on 2023/07/31.
//

import Foundation

struct UserResponseDTO: Decodable {
    let usersId: String
    let nickname: String
    let reviewScore: Double
    let reviewCount: Int
    let rentingCount: Int
    let returningCount: Int
    let buyCount: Int
    let sellCount: Int
}
