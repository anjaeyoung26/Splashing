//
//  SplashCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/15.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class SplashCoordinator: CoordinatorType {
    var baseViewController: UIViewController
    var coordinator: CoordinatorType?
    var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
        
        let provider = ServiceProvider()
        let viewModel = SplashViewModel(provider: provider)
        
        baseViewController = SplashViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        switch transition {
        case .showLogin:
            coordinator = LoginCoordinator()
        case .showMain:
            coordinator = MainCoordinator()
        default:
            return
        }
        
        window?.rootViewController = coordinator?.baseViewController
    }
}
