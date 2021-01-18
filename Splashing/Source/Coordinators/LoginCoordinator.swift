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
    var coordinator: CoordinatorType?
    
    init() {
        let provider = ServiceProvider()
        let viewModel = LoginViewModel(provider: provider)
        
        baseViewController = LoginViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        switch transition {
        case .showMain:
            coordinator = MainCoordinator()
        default:
            return
        }
        
        if let target = coordinator?.baseViewController {
            target.modalPresentationStyle = .fullScreen
            baseViewController.present(target, animated: true, completion: nil)
        }
    }
}
