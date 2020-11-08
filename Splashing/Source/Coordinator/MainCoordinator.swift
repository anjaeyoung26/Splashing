//
//  MainCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class MainCoordinator: BaseCoordinator<Void> {
  
  private let viewModel: MainViewModel
  
  init(viewModel: MainViewModel) {
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
    
    viewModel.input.profileButtonTapped
      .observeOn(MainScheduler.instance)
      .flatMap {
        self.transition(.profile)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    viewModel.input.settingButtonTapped
      .observeOn(MainScheduler.instance)
      .flatMap {
        self.transition(.setting)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    viewModel.input.searchBarTapped
      .observeOn(MainScheduler.instance)
      .flatMap {
        self.transition(.search)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
}
