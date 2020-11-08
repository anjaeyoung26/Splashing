//
//  SFSymbol.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/09.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

enum SFSymbol {
  static func download(size: CGFloat) -> UIImage {
  let configuration = UIImage.SymbolConfiguration(pointSize: size)
    return UIImage(systemName: "square.and.arrow.down", withConfiguration: configuration)!
  }

  static let heart  = UIImage(systemName: "heart.fill")
  static let back   = UIImage(systemName: "chevron.left")
}
