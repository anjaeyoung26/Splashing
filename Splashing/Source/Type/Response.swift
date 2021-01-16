//
//  Response.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/20.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

struct Response {
    let data: Data
    let response: HTTPURLResponse
    
    init(data: Data, response: HTTPURLResponse) {
        self.data     = data
        self.response = response
    }
}
