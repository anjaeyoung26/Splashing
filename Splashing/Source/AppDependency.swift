//
//  AppDependency.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import Swinject

enum AppDependency {
    static let container = Container() { container in
        container.register(NetworkingProtocol.self) { _ in Networking() }.inObjectScope(.container)
        container.register(AuthServiceType.self)    { _ in AuthService() }.inObjectScope(.container)
        
        container.register(UserServiceType.self) { r in
            return UserService(networking: r.resolve(NetworkingProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(PhotoServiceType.self) { r in
            return PhotoService(networking: r.resolve(NetworkingProtocol.self)!)
        }.inObjectScope(.graph)
        
        container.register(LoginViewModel.self) { r in
            let dependency = LoginViewModel.Dependency(authService: r.resolve(AuthServiceType.self)!,
                                                       userService: r.resolve(UserServiceType.self)!)
            let viewModel  = LoginViewModel(dependency: dependency)
            
            return viewModel
        }.inObjectScope(.container)
        
        container.register(MainViewModel.self) { r in
            let dependency = MainViewModel.Dependency(photoService: r.resolve(PhotoServiceType.self)!)
            let viewModel  = MainViewModel(dependency: dependency)
            
            return viewModel
        }.inObjectScope(.container)
        
        container.register(ProfileViewModel.self) { r in
            let dependency = ProfileViewModel.Dependency(authService: r.resolve(AuthServiceType.self)!,
                                                         userService: r.resolve(UserServiceType.self)!,
                                                         photoService: r.resolve(PhotoServiceType.self)!)
            let viewModel  = ProfileViewModel(dependency: dependency)
            
            return viewModel
        }.inObjectScope(.container)
        
        container.register(SearchViewModel.self) { r in
            let dependency = SearchViewModel.Dependency(photoService: r.resolve(PhotoServiceType.self)!)
            let viewModel  = SearchViewModel(dependency: dependency)
            
            return viewModel
        }.inObjectScope(.container)
        
        container.register(SplashViewModel.self) { r in
            let dependency = SplashViewModel.Dependency(userService: r.resolve(UserServiceType.self)!)
            let viewModel  = SplashViewModel(dependency: dependency)
            
            return viewModel
        }.inObjectScope(.container)
        
        container.register(DetailViewModel.self) { r in
            let dependency = DetailViewModel.Dependency(photoService: r.resolve(PhotoServiceType.self)!)
            let viewModel  = DetailViewModel(dependency: dependency)
            
            return viewModel
        }.inObjectScope(.graph)
        
        container.register(MainViewController.self) { r in
            let viewController = MainViewController()
            
            viewController.viewModel              = r.resolve(MainViewModel.self)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle   = .crossDissolve
            
            return viewController
        }.inObjectScope(.container)
        
        container.register(ProfileViewController.self) { r in
            let viewController = ProfileViewController()
            
            viewController.viewModel = r.resolve(ProfileViewModel.self)
            
            return viewController
        }.inObjectScope(.container)
        
        container.register(SearchViewController.self) { r in
            let viewController = SearchViewController()
            
            viewController.viewModel              = r.resolve(SearchViewModel.self)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle   = .crossDissolve
            
            return viewController
        }.inObjectScope(.container)
        
        container.register(LoginViewController.self) { r in
            let viewController = LoginViewController()
            
            viewController.viewModel              = r.resolve(LoginViewModel.self)
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle   = .crossDissolve
            
            return viewController
        }.inObjectScope(.container)
        
        container.register(SplashViewController.self) { r in
            let viewController = SplashViewController()
            
            viewController.viewModel = r.resolve(SplashViewModel.self)
            
            return viewController
        }.inObjectScope(.graph)
        
        container.register(DetailViewController.self) { r in
            let viewController = DetailViewController()
            
            viewController.viewModel = r.resolve(DetailViewModel.self)
            
            return viewController
        }.inObjectScope(.graph)
    }
}
