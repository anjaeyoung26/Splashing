//
//  LoginCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class LoginCoordinator: BaseCoordinator<Void> {
  
  private let viewModel: LoginViewModel
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
  }
  
  override func start() -> Observable<Void> {
    viewModel.output.setLoggedIn
      .observeOn(MainScheduler.instance)
      .flatMap { setLoggedIn -> Observable<Void> in
        if setLoggedIn {
          return self.transition(.main)
        } else {
          return .never()
        }
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
}

