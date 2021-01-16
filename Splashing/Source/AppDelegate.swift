//
//  AppDelegate.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var splashCoordinator: SplashCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard var _window = window else {
            print("Could not load window.")
            return false
        }
        
        splashCoordinator = SplashCoordinator(window: _window)
        
        _window = UIWindow(frame: UIScreen.main.bounds)
        _window.rootViewController = splashCoordinator?.baseViewController
        _window.backgroundColor = .white
        _window.makeKeyAndVisible()
        
        return true
    }
}

