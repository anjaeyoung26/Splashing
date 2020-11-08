//
//  AppCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class AppCoordinator: BaseCoordinator<Void> {
  
  private let window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
  }
  
  override func start() -> Observable<Void> {
    return self.transition(.splash(window: window))
  }
}
