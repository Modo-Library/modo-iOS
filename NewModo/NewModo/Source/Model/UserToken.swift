//
//  UserToken.swift
//  NewModo
//
//  Created by MacBook on 2023/07/20.
//

import Foundation

struct UserToken: Codable {
    var accessToken: String
    var refreshToken: String
    var usersId: String
}
