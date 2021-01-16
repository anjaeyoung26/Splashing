//
//  CoordinatorType.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/15.
//  Copyright © 2021 안재영. All rights reserved.
//

import UIKit

protocol CoordinatorType: class {
    var baseViewController: UIViewController { get }
    
    func performTransition(_ transition: Transition)
}
