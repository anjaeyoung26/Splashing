//
//  AccessToken.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/01.
//  Copyright © 2020 안재영. All rights reserved.
//

struct AccessToken: Decodable {
    var number: String
    var type  : String
    var scope : String
    
    init(number: String, type: String, scope: String) {
        self.number = number
        self.type   = type
        self.scope  = scope
    }
}

extension AccessToken {
    enum CodingKeys: String, CodingKey {
        case number = "access_token"
        case type   = "token_type"
        case scope
    }
}
