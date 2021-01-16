//
//  AppDelegate.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let disposeBag = DisposeBag()
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        return true
    }
}

