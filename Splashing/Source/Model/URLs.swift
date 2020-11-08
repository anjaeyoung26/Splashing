//
//  URLs.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/14.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

extension Photo {
  struct URLs: Decodable {
    var raw    : String
    var full   : String
    var regular: String
    var small  : String
    var thumb  : String
  }
}
