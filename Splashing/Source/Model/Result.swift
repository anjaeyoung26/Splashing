//
//  Result.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/10.
//  Copyright © 2020 안재영. All rights reserved.
//

struct Result: Decodable {
    var total  : Int
    var pages  : Int
    var results: [Photo]
}

extension Result {
    enum CodingKeys: String, CodingKey {
        case total, results
        case pages = "total_pages"
    }
}
