//
//  SettingViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/02.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    enum Height {
        static let logo = 30
    }
    
    let logo = UIImageView().then {
        $0.image = Icon.unsplashLogoWhite
    }
    
    let caption = UILabel().then {
        $0.font      = Font.Helvetica.bold(size: 25)
        $0.textColor = .white
        $0.text = "Splashing"
    }
    
    let doneButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Done",      for: .normal)
    }
    
    let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "SettingViewController")
        $0.backgroundColor = .black
    }
    
    let viewModel: SettingTableViewModel
    
    init(viewModel: SettingTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewModel = SettingTableViewModel(viewController: self)
        
        tableView.delegate   = tableViewModel
        tableView.dataSource = tableViewModel
    }
    
    override func addSubview() {
        [doneButton, logo, caption, tableView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        doneButton.snp.makeConstraints {
            $0.top.right.equalTo(view.readableContentGuide)
        }
        
        logo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(doneButton.snp.bottom)
            $0.width.height.equalTo(Height.logo)
        }
        
        caption.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(caption.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func binding() {
        doneButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
