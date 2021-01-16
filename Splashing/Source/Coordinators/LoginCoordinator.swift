//
//  LoginCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/16.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class LoginCoordinator: CoordinatorType {
    
    var baseViewController: UIViewController
    
    init() {
        let provider = ServiceProvider()
        let viewModel = LoginViewModel(provider: provider)
        
        baseViewController = LoginViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        switch transition {
        case .showMain:
            let coordinator = MainCoordinator()
            
            baseViewController.present(coordinator.baseViewController, animated: true, completion: nil)
        default:
            return
        }
    }
}
