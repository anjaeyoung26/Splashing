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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        splashCoordinator = SplashCoordinator(window: window!)
        
        window?.rootViewController = splashCoordinator?.baseViewController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }
}

