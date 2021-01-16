//
//  Bundle.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

extension Bundle {
    var accessKey: String {
        let path  = Bundle.main.path(forResource: "key", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: path!)
        let key   = plist!["AccessKey"] as! String
        return key
    }
    
    var secretKey: String {
        let path  = Bundle.main.path(forResource: "key", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: path!)
        let key   = plist!["SecretKey"] as! String
        return key
    }
}
