//
//  Scene.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/17.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

enum Scene {
  case splash(window: UIWindow)
  case login
  case main
  case detail(photo: Photo)
  case profile
  case search
  case setting
}
