//
//  SplashCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/15.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class SplashCoordinator: CoordinatorType {
    var window: UIWindow?
    var baseViewController: UIViewController
    
    init(window: UIWindow) {
        self.window = window
        
        let provider = ServiceProvider()
        let viewModel = SplashViewModel(provider: provider)
        
        baseViewController = SplashViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        guard let _window = window else { return }
        
        switch transition {
        case .showLogin:
            let coordinator = LoginCoordinator()
        
            _window.rootViewController = coordinator.baseViewController
        case .showMain:
            let coordinator = MainCoordinator()
        
            _window.rootViewController = coordinator.baseViewController
        default:
            return
        }
    }
}
