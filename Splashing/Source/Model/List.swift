//
//  List.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/21.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

struct List<Item> {
  var item   : [Item]
  var nextURL: URL?
  
  init(item: [Item], nextURL: URL? = nil) {
    self.item    = item
    self.nextURL = nextURL
  }
}
