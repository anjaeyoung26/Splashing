//
//  SettingCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/17.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

class SettingCoordinator: CoordinatorType {
    var baseViewController: UIViewController
    
    init() {
        baseViewController = SettingViewController()
    }
    
    func performTransition(_ transition: Transition) {
        
    }
}
