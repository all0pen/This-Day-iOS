//
//  LoginInfo.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 9..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import Foundation

class LoginInfo: Codable {
    var id: Int?
    var userID: String?
    var userPassword: String?
    
    static let shared: LoginInfo = LoginInfo()
}
