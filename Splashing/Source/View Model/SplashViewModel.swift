//
//  SplashViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/04.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift

class SplashViewModel: ViewModel {
  
  struct Input {
    let viewDidAppear = PublishRelay<Void>()
  }
  
  struct Output {
    let isLoading       = ActivityIndicator()
    let isAuthenticated = PublishRelay<Bool>()
  }
  
  struct Dependency {
    let userService: UserServiceType
  }
  
  let input      = Input()
  let output     = Output()
  let disposeBag = DisposeBag()
  
  let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
    
    input.viewDidAppear
      .flatMap {
        self.dependency.userService.fetch()
          .trackActivity(self.output.isLoading)
      }
      .asObservable()
      .map { true }
      .catchErrorJustReturn(false)
      .bind(to: output.isAuthenticated)
      .disposed(by: disposeBag)
  }
}
