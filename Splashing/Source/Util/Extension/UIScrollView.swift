//
//  UIScrollView.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/22.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

extension UIScrollView {
  func isReachedBottom() -> Bool {
    return self.contentOffset.y >= (self.contentSize.height - self.frame.size.height)
  }
}
