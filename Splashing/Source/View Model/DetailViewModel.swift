//
//  DetailViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/09.
//  Copyright © 2020 안재영. All rights reserved.
//

import Photos
import RxCocoa
import RxSwift

class DetailViewModel: ViewModel {

  struct Input {
    let downloadButtonTapped = PublishRelay<Void>()
    let currentPhoto         = PublishRelay<Photo>()
  }

  struct Output {
    let downloadResult = PublishRelay<Bool>()
  }

  struct Dependency {
    let photoService: PhotoServiceType
  }

  let input      = Input()
  let output     = Output()
  let disposeBag = DisposeBag()

  let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
    
    let downloadLink = input.currentPhoto
      .flatMap {
        self.dependency.photoService.downloadLink(id: $0.id)
      }
      .share()
    
    let image = downloadLink
      .compactMap { URL(string: $0.url) }
      .compactMap { try? Data(contentsOf: $0) }
      .compactMap { UIImage(data: $0) }
    
    input.downloadButtonTapped
      .withLatestFrom(image)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .flatMap {
        PHPhotoLibrary.shared().save(image: $0)
      }
      .bind(to: output.downloadResult)
      .disposed(by: disposeBag)
  }
}
