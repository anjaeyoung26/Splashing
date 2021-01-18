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
    var coordinator: CoordinatorType?
    
    init() {
        let provider = ServiceProvider()
        let viewModel = MainViewModel(provider: provider)
        
        baseViewController = MainViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
    }
    
    func performTransition(_ transition: Transition) {
        switch transition {
        case .showDetail(let item):
            coordinator = DetailCoordinator(item: item)
        case .showProfile:
            coordinator = ProfileCoordinator()
        case .showSearch:
            coordinator = SearchCoordinator()
        case .showSetting:
            coordinator = SettingCoordinator()
        default:
            return
        }
        
        if let target = coordinator?.baseViewController {
            target.modalPresentationStyle = .fullScreen
            baseViewController.present(target, animated: true, completion: nil)
        }
    }
}
