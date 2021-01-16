//
//  MainCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/16.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class MainCoordinator: CoordinatorType {
    var baseViewController: UIViewController
    
    init() {
        let provider = ServiceProvider()
        let viewModel = MainViewModel(provider: provider)
        
        baseViewController = MainViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        switch transition {
        case .showDetail(let photo):
            let coordinator = DetailCoordinator()

            baseViewController.present(coordinator.baseViewController, animated: true, completion: nil)
        case .showProfile:
            let coordinator = ProfileCoordinator()
            
            baseViewController.present(coordinator.baseViewController, animated: true, completion: nil)
        case .showSearch:
            let coordinator = SearchCoordinator()
            
            baseViewController.present(coordinator.baseViewController, animated: true, completion: nil)
        default:
            return
        }
    }
}
