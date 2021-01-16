//
//  ProfileViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/02.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift

class ProfileViewModel: ViewModel {
    
    struct Input {
        let logoutButtonTapped = PublishRelay<Void>()
        let photoSelected      = PublishRelay<Photo>()
        let viewDidAppear      = PublishRelay<Void>()
        let segmentIndex       = PublishRelay<Int>()
    }
    
    struct Output {
        let completeLogout = PublishRelay<Void>()
        let currentUser    = PublishRelay<User?>()
        let photos         = PublishRelay<[Photo]>()
    }
    
    let input      = Input()
    let output     = Output()
    let disposeBag = DisposeBag()
    
    let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        input.logoutButtonTapped
            .map {
                self.provider.authService.logout()
            }
            .bind(to: output.completeLogout)
            .disposed(by: disposeBag)
        
        let currentUser = input.viewDidAppear
            .flatMap {
                self.provider.userService.currentUser
            }
            .share()
        
        currentUser
            .bind(to: output.currentUser)
            .disposed(by: disposeBag)
        
        let name = currentUser
            .compactMap { $0?.name }
        
        let trigger = input.segmentIndex
            .asObservable()
        
        Observable
            .combineLatest(name, trigger)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { name, trigger -> Single<[Photo]> in
                switch trigger {
                case 0:
                    return self.provider.photoService.users(name: name)
                case 1:
                    return self.provider.photoService.liked(name: name)
                default:
                    return .never()
                }
            }
            .bind(to: output.photos)
            .disposed(by: disposeBag)
    }
}
