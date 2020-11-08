//
//  SplashCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class SplashCoordinator: BaseCoordinator<Void> {
  
  private let window: UIWindow
  private let viewModel: SplashViewModel
  
  init(window: UIWindow, viewModel: SplashViewModel) {
    self.window = window
    self.viewModel = viewModel
  }
  
  override func start() -> Observable<Void> {
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    
    viewModel.output.isAuthenticated
      .observeOn(MainScheduler.instance)
      .flatMap { isAuthenticated -> Observable<Void> in
        if isAuthenticated {
          return self.transition(.main)
        } else {
          return self.transition(.login)
        }
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
}
