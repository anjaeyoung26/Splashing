//
//  MainViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxOptional
import RxCocoa
import RxSwift

class MainViewModel: ViewModel {
    
    struct Input {
        let viewDidAppear       = PublishRelay<Void>()
        let photoSelected       = PublishRelay<Photo>()
        let isReachedBottom     = PublishRelay<Bool>()
        let searchBarTapped     = PublishRelay<Void>()
        let profileButtonTapped = PublishRelay<Void>()
        let settingButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let latestPhotos = PublishRelay<[Photo]>()
        let randomPhoto  = PublishRelay<Photo>()
    }
    
    let input      = Input()
    let output     = Output()
    let disposeBag = DisposeBag()
    
    let provider: ServiceProviderType
    
    weak var coordinator: CoordinatorType?
    
    private let nextURL = PublishSubject<URL?>()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        // Coordinate
        input.photoSelected
            .subscribe(onNext: { [weak self] photo in
                guard let `self` = self else { return }
                self.coordinator?.performTransition(.showDetail(photo))
            })
            .disposed(by: disposeBag)
        
        input.searchBarTapped
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.performTransition(.showSearch)
            })
            .disposed(by: disposeBag)
        
        input.profileButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.performTransition(.showProfile)
            })
            .disposed(by: disposeBag)
        
        input.settingButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.performTransition(.showSetting)
            })
            .disposed(by: disposeBag)
        
        // Business logic
        let reachedBottom = input.isReachedBottom
            .filterTrue()
        
        let loadMore = reachedBottom
            .withLatestFrom(nextURL)
            .filterNil()
            .flatMap {
                self.provider.photoService.url($0)
            }
            .share()
        
        loadMore
            .map { $0.nextURL }
            .bind(to: self.nextURL)
            .disposed(by: disposeBag)
        
        let viewDidAppearEvent = input.viewDidAppear
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .share()
        
        let latestPhotos = viewDidAppearEvent
            .flatMap {
                self.provider.photoService.latest()
            }
            .share()
        
        Observable
            .combineLatest(
                latestPhotos.map { $0.item },
                loadMore.map { $0.item }
            )
            { $0 + $1 }
            .bind(to: output.latestPhotos)
            .disposed(by: disposeBag)
        
        let randomPhotos = viewDidAppearEvent
            .flatMap {
                self.provider.photoService.random()
            }
            .share()
        
        latestPhotos
            .map { $0.nextURL }
            .bind(to: self.nextURL)
            .disposed(by: disposeBag)
        
        latestPhotos
            .map { $0.item }
            .bind(to: output.latestPhotos)
            .disposed(by: disposeBag)
        
        randomPhotos
            .compactMap { $0.first }
            .bind(to: output.randomPhoto)
            .disposed(by: disposeBag)
    }
}
