//
//  DetailCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/16.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class DetailCoordinator: CoordinatorType {
    var baseViewController: UIViewController
    
    init() {
        let provider = ServiceProvider()
        let viewModel = DetailViewModel(provider: provider)
        
        baseViewController = DetailViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        
    }
}
