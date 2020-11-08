//
//  UserDefaults.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/14.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation
//from https://www.raywenderlich.com/9009-requesting-app-ratings-and-reviews-tutorial-for-ios
extension UserDefaults {
  enum Key: String {
    case reviewWorthyActionCount
    case lastReviewRequestAppVersion
  }

  func integer(forKey key: Key) -> Int {
    return integer(forKey: key.rawValue)
  }

  func string(forKey key: Key) -> String? {
    return string(forKey: key.rawValue)
  }

  func set(_ integer: Int, forKey key: Key) {
    set(integer, forKey: key.rawValue)
  }

  func set(_ object: Any?, forKey key: Key) {
    set(object, forKey: key.rawValue)
  }
}
