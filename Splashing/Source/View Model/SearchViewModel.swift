//
//  SearchViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/10.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift

class SearchViewModel: ViewModel {
    
    struct Input {
        let searchButtonTapped = PublishRelay<String>()
        let photoSelected      = PublishRelay<Photo>()
    }
    
    struct Output {
        let searchResult = PublishRelay<[Photo]>()
    }
    
    struct Dependency {
        let photoService: PhotoServiceType
    }
    
    let input      = Input()
    let output     = Output()
    let disposeBag = DisposeBag()
    
    let provider: ServiceProviderType
    
    weak var coordinator: CoordinatorType?
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        input.photoSelected
            .subscribe(onNext: { [weak self] photo in
                guard let `self` = self else { return }
                self.coordinator?.performTransition(.showDetail(photo))
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
            .flatMap {
                self.provider.photoService.search(query: $0)
            }
            .bind(to: output.searchResult)
            .disposed(by: disposeBag)
    }
}
