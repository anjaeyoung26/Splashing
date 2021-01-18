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
    }
    
    struct Dependency {
        let userService: UserServiceType
    }
    
    let input      = Input()
    let output     = Output()
    let disposeBag = DisposeBag()
    
    let provider: ServiceProviderType
    
    weak var coordinator: CoordinatorType?
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        input.viewDidAppear
            .flatMap {
                self.provider.userService.fetchMe()
                    .trackActivity(self.output.isLoading)
            }
            .map { true }
            .catchErrorJustReturn(false)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoggedIn in
                guard let weakSelf = self else { return }
                if isLoggedIn {
                    weakSelf.coordinator?.performTransition(.showMain)
                } else {
                    weakSelf.coordinator?.performTransition(.showLogin)
                }
            })
            .disposed(by: disposeBag)
    }
}
