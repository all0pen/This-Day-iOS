//
//  Calendar.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 10..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import Foundation

struct Calendar: Codable {
    let date: [Date]
    let userInfo: String // 캘린더 사용 유저 정보
}

struct Date: Codable { // 캘린더 날짜 정보
    let year: String
    let month: String
    let day: String
    
    let chosenDay: [ChosenDay]
}

struct ChosenDay: Codable { // 선택한 날
    let title: String // 그 날 할 일 제목
    let memo: String
    let color: String
    
}

//1. 개인 캘린더
//1-1. 캘린더 안 세부내용 포함
//0)) 제목(할 일) ok
//1)) 날짜(년, 월, 일) ok
//3)) 메모 ok
//4)) 지정색깔 ok
//5)) 유저 정보
