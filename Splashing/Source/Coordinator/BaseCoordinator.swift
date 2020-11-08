//
//  BaseCoordinator.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/13.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator<Result> {

  var disposeBag = DisposeBag()
  
  var viewController: UIViewController?
  
  private let identifier = UUID()
  
  private var childCoordinators = [UUID: Any]()
  
  private func store<T>(coordinator: BaseCoordinator<T>) {
    childCoordinators[coordinator.identifier] = coordinator
  }
  
  private func free<T>(coordinator: BaseCoordinator<T>) {
    childCoordinators[coordinator.identifier] = nil
  }
  
  func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
    store(coordinator: coordinator)
    return coordinator.start()
      .do(onNext: { [weak self] _ in
        self?.free(coordinator: coordinator)
      })
  }
  
  func start() -> Observable<Result> {
    fatalError("Start method should be implemented.")
  }
  
  func transition(_ scene: Scene) -> Observable<Result> {
    let container = AppDependency.container
    
    switch scene {
    case .splash(let window):
      let viewControllerSplash = container.resolve(SplashViewController.self)!
      let viewModelSplash      = container.resolve(SplashViewModel.self)!
      
      let coordinator = SplashCoordinator(window: window, viewModel: viewModelSplash)
      coordinator.viewController = viewControllerSplash

      return coordinate(to: coordinator as! BaseCoordinator<Result>)

    case .login:
      let viewControllerLogin = container.resolve(LoginViewController.self)!
      let viewModelLogin      = container.resolve(LoginViewModel.self)!
      
      let coordinator = LoginCoordinator(viewModel: viewModelLogin)

      coordinator.viewController = viewControllerLogin
      
      if let viewController = viewController {
        viewController.present(viewControllerLogin, animated: true, completion: nil)
      }

      return coordinate(to: coordinator as! BaseCoordinator<Result>)
      
    case .detail(let photo):
      let viewControllerDetail = container.resolve(DetailViewController.self)!
      let viewModelDetail      = container.resolve(DetailViewModel.self)!
      
      viewControllerDetail.photo = photo
      
      let coordinator = DetailCoordinator(viewModel: viewModelDetail)
      
      coordinator.viewController = viewControllerDetail
      
      if let viewController = viewController {
        viewController.present(viewControllerDetail, animated: true, completion: nil)
      }

      return coordinate(to: coordinator as! BaseCoordinator<Result>)

    case .main:
      let viewControllerMain = container.resolve(MainViewController.self)!
      let viewModelMain      = container.resolve(MainViewModel.self)!
      
      let coordinator = MainCoordinator(viewModel: viewModelMain)

      coordinator.viewController = viewControllerMain
      
      if let viewController = viewController {
        viewController.present(viewControllerMain, animated: true, completion: nil)
      }

      return coordinate(to: coordinator as! BaseCoordinator<Result>)

    case .profile:
      let viewControllerProfile = container.resolve(ProfileViewController.self)!
      let viewModelProfile      = container.resolve(ProfileViewModel.self)!
      
      let coordinator = ProfileCoordinator(viewModel: viewModelProfile)

      coordinator.viewController = viewControllerProfile
      
      if let viewController = viewController {
        viewController.present(viewControllerProfile, animated: true, completion: nil)
      }

      return coordinate(to: coordinator as! BaseCoordinator<Result>)

    case .search:
      let viewControllerSearch = container.resolve(SearchViewController.self)!
      let viewModelSearch      = container.resolve(SearchViewModel.self)!
      
      let coordinator = SearchCoordinator(viewModel: viewModelSearch)

      coordinator.viewController = viewControllerSearch
      
      if let viewController = viewController {
        viewController.present(viewControllerSearch, animated: true, completion: nil)
      }

      return coordinate(to: coordinator as! BaseCoordinator<Result>)

    case .setting:
      let viewControllerSetting = SettingViewController()
      let coordinator = SettingCoordinator()

      coordinator.viewController = viewControllerSetting
      
      if let viewController = viewController {
        viewController.present(viewControllerSetting, animated: true, completion: nil)
      }

      return coordinate(to: coordinator as! BaseCoordinator<Result>)
    }
  }
}
