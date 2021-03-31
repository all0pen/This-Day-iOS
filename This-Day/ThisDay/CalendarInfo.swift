//
//  CalendarInfo.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 15..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import Foundation

struct CalendarInfo: Codable {
    var title: String?
    var memo: String?
    // var date: CVDate!
    var date: String?
    var userID: Int?
}
