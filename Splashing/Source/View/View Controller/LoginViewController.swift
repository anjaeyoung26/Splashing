//
//  LoginViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/01.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

class LoginViewController: BaseViewController {
    
    struct Height {
        static let loginButton = 40
        static let logo        = 130
    }
    
    let logo = UIImageView().then {
        $0.image = Icon.unsplashLogoWhite
    }
    
    let caption = UILabel().then {
        $0.font      = Font.Helvetica.bold(size: 40)
        $0.textColor = .white
        $0.text      = "Splashing"
    }
    
    let loginButton = UIButton().then {
        let backgroundImage = UIImage.resizable().color(.white).corner(radius: 5).image
        $0.setTitle("Login with Unsplash",     for: .normal)
        $0.setTitleColor(.black,               for: .normal)
        $0.setBackgroundImage(backgroundImage, for: .normal)
        $0.titleLabel?.font = Font.Helvetica.medium(size: 17)
    }
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large).then {
        $0.color = .white
    }
    
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
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
        [logo, caption, loginButton, activityIndicatorView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        logo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.width.height.equalTo(Height.logo)
        }
        
        caption.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(30)
        }
        
        loginButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.height.equalTo(Height.loginButton)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalTo(loginButton)
        }
    }
    
    override func binding() {
        loginButton.rx.tap
            .bind(to: viewModel.input.loginButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .asDriver()
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        let isLoading = viewModel.output.isLoading
            .asSharedSequence()
            .asDriver()
        
        isLoading
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        isLoading
            .drive(self.loginButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
