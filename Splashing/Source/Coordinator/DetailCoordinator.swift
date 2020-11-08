//
//  DetailCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class DetailCoordinator: BaseCoordinator<Void> {
  
  private let viewModel: DetailViewModel
  
  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
  }
  
  override func start() -> Observable<Void> {
    return .never()
  }
}
