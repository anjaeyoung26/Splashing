//
//  ProfileCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class ProfileCoordinator: BaseCoordinator<Void> {
  
  private let viewModel: ProfileViewModel
  
  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
  }

  override func start() -> Observable<Void> {
    viewModel.input.photoSelected
      .observeOn(MainScheduler.instance)
      .flatMap {
        self.transition(.detail(photo: $0))
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
}
