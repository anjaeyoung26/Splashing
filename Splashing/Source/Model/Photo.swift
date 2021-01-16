//
//  Photo.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    var id         : String
    var user       : User
    var width      : Int
    var height     : Int
    var likes      : Int
    var description: String?
    var urls       : URLs
}

extension Photo {
    enum Fit: String {
        case clip  = "clip"// Default. 이미지를 자르거나 왜곡하지 않고 너비 및 높이 경계(boundaries)에 맞게 이미지 크기를 조정합니다.
        case crop  = "crop"// 너비 및 높이 치수를 채우도록 이미지 크기를 조정하고 초과 이미지 데이터를 자릅니다.
        case clamp = "clamp"// 이미지를 자르거나 왜곡하지 않고 너비 및 높이 치수(dimensions)에 맞게 이미지 크기를 조정합니다.
    }
}

extension Photo {
    func transform(
        width : String,
        height: String,
        fit   : Fit = .clamp)
    -> URL? {
        guard var components = URLComponents(string: self.urls.raw) else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "w",   value: width),
            URLQueryItem(name: "h",   value: height),
            URLQueryItem(name: "fit", value: fit.rawValue)
        ]
        
        return components.url
    }
}
