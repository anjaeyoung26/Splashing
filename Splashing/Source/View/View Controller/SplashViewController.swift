//
//  SplashViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/04.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class SplashViewController: BaseViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .white
    }
    
    let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubview() {
        view.addSubview(activityIndicator)
    }
    
    override func setConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func binding() {
        self.rx.viewDidAppear
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
