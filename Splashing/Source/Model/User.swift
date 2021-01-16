//
//  User.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

struct User: Decodable {
    var name  : String
    var likes : Int
    var photos: Int
    var images: Image
}

extension User {
    enum CodingKeys: String, CodingKey {
        case name   = "username"
        case likes  = "total_likes"
        case photos = "total_photos"
        case images = "profile_image"
    }
}

extension User {
    struct Image: Decodable {
        var small : String
        var medium: String
    }
}
