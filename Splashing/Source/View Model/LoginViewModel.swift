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
    }
    
    let input      = Input()
    let output     = Output()
    let disposeBag = DisposeBag()
    
    let provider: ServiceProviderType
    
    weak var coordinator: CoordinatorType?
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        let setLoggedIn = input.loginButtonTapped
            .flatMap {
                self.provider.authService.authorize()
            }
            .asObservable()

        setLoggedIn
            .flatMap {
                self.provider.userService.fetchMe()
                    .trackActivity(self.output.isLoading)
            }
            .map { true }
            .catchErrorJustReturn(false)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoggedIn in
                guard let `self` = self else { return }
                if isLoggedIn {
                    self.coordinator?.performTransition(.showMain)
                } else {
                    Toaster.show(message: "Could not login. Please retry or check your account.", delay: 1.5, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
