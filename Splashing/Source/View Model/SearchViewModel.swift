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
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    
    input.searchButtonTapped
      .flatMap {
        self.provider.photoService.search(query: $0)
      }
      .bind(to: output.searchResult)
      .disposed(by: disposeBag)
  }
}
