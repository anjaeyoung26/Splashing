//
//  SearchCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class SearchCoordinator: BaseCoordinator<Void> {
  
  private let viewModel: SearchViewModel
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
  }

  override func start() -> Observable<Void> {
    viewModel.input.photoSelected
      .flatMap {
        self.transition(.detail(photo: $0))
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
}
