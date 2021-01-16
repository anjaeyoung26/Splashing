//
//  SearchCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/16.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class SearchCoordinator: CoordinatorType {
    var baseViewController: UIViewController
    
    init() {
        let provider = ServiceProvider()
        let viewModel = SearchViewModel(provider: provider)
        
        baseViewController = SearchViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        switch transition {
        case .showDetail:
            let coordinator = DetailCoordinator()
            
            baseViewController.present(coordinator.baseViewController, animated: true, completion: nil)
        default:
            return
        }
    }
}
