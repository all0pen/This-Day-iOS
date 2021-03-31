//
//  UserModel.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 10..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import Foundation

final class UserModel {
    //저장된 계정 정보
    var model: [User] = [
        User(id: "admin@admin.com", password: "12345678"),
        User(id: "usinuniverse@gmail.com", password: "12345678")
    ]
    
    struct User {
        var id: String
        var password: String
    }
    
    //계정 정보 확인 함수
    func findUser(inputID: String, inputPassword: String) -> Bool {
        for user in model {
            if user.id == inputID && user.password == inputPassword {
                return true
            }
        }
        return false
    }
    
    //회원 추가 함수
    func addUser(newID: String, newPassword: String) {
        let newUser = User(id: newID, password: newPassword)
        model.append(newUser)
    }
}
