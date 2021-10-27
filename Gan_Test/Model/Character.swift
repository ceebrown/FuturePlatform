//
//  Character.swift
//  Gan_Test
//
//  Created by Clive Brown on 09/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import Foundation

struct Character: Codable {
    var charId: Int
    var name: String
    var birthday: String
    var occupation: [String]?
    var img: String
    var status: String
    var nickname: String
    var appearance: [Int]?
    var portrayed: String
    var category: String
    var betterCallSaulAppearance: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case charId = "char_id"
        case name
        case birthday
        case occupation
        case img
        case status
        case nickname
        case appearance
        case portrayed
        case category
        case betterCallSaulAppearance = "better_call_saul_appearance"
    }
}
