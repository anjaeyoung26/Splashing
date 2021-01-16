//
//  LoginViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/01.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift

class LoginViewModel: ViewModel {
  
  struct Input {
    let loginButtonTapped = PublishRelay<Void>()
  }
  
  struct Output {
    let isLoading   = ActivityIndicator()
    let setLoggedIn = PublishRelay<Bool>()
  }

  let input      = Input()
  let output     = Output()
  let disposeBag = DisposeBag()
    
  let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
    
    let setLoggedIn = input.loginButtonTapped
      .flatMap {
        self.provider.authService.authorize()
      }
      .asObservable()
    
    setLoggedIn
      .flatMap {
        self.provider.userService.fetch()
          .trackActivity(self.output.isLoading)
      }
      .map { true }
      .catchErrorJustReturn(false)
      .bind(to: output.setLoggedIn)
      .disposed(by: disposeBag)
  }
}
