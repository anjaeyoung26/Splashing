//
//  MainViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxKingfisher
import RxCocoa
import RxSwift
import UIKit

class MainViewController: BaseViewController {
    
    enum Height {
        static let backgroundImage = Screen.height / 2
        static let profileButton   = 40
        static let settingButton   = 30
        static let searchBar       = 50
        static let caption         = 50
        static let remark          = 30
        static let new             = 30
    }
    
    let scrollView = UIScrollView(frame: Screen.frame).then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.bounces = false
    }
    
    let backgroundImage = UIImageView().then {
        $0.contentMode   = .center
        $0.clipsToBounds = true
    }
    
    let settingButton = UIButton().then {
        $0.setImage(Icon.unsplashLogoWhite, for: .normal)
    }
    
    let profileButton = UIButton().then {
        $0.setImage(Icon.user, for: .normal)
    }
    
    let caption = UILabel().then {
        $0.font      = Font.Helvetica.bold(size: 30)
        $0.textColor = .white
        $0.text      = "Photos for everyone"
    }
    
    let searchBar = UISearchBar().then {
        $0.searchTextField.backgroundColor     = UIColor.lightGray.withAlphaComponent(0.8)
        $0.searchTextField.font                = UIFont.systemFont(ofSize: 15)
        $0.searchTextField.leftView?.tintColor = .white
        $0.searchTextField.textColor           = .white
        $0.searchBarStyle = .minimal
    }
    
    let remark = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .white
    }
    
    let new = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textColor = .white
        $0.text = "New"
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.register(ShotCollectionViewCell.self, forCellWithReuseIdentifier: "MainViewController")
        $0.isScrollEnabled = false
    }
    
    let flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }
    
    let latestPhotos = BehaviorRelay<[Photo]>(value: [])
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func addSubview() {
        [backgroundImage, settingButton, profileButton, caption, searchBar, remark, new, collectionView].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.snp.updateConstraints {
            $0.top.equalTo(new.snp.bottom).offset(20)
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(collectionView.contentSize.height + 10)
        }
    }
    
    override func setConstraints() {
        backgroundImage.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(Height.backgroundImage)
        }
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(backgroundImage.snp.top).offset(50)
            $0.left.equalTo(backgroundImage.snp.left).offset(20)
            $0.width.height.equalTo(Height.settingButton)
        }
        
        profileButton.snp.makeConstraints {
            $0.top.equalTo(backgroundImage.snp.top).offset(45)
            $0.right.equalTo(backgroundImage.snp.right).offset(-20)
            $0.width.height.equalTo(Height.profileButton)
        }
        
        caption.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(searchBar.snp.top)
            $0.height.equalTo(Height.caption)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(backgroundImage.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-30)
            $0.height.equalTo(Height.searchBar)
        }
        
        remark.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Height.remark)
        }
        
        new.snp.makeConstraints {
            $0.top.equalTo(backgroundImage.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(Height.new)
        }
    }
    
    override func binding() {
        self.rx.viewDidAppear
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .bind(to: viewModel.input.settingButtonTapped)
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .bind(to: viewModel.input.profileButtonTapped)
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .bind(to: viewModel.input.searchBarTapped)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { indexPath in
                self.latestPhotos.value[indexPath.row]
            }
            .bind(to: viewModel.input.photoSelected)
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .map {
                self.scrollView.isReachedBottom()
            }
            .distinctUntilChanged()
            .bind(to: viewModel.input.isReachedBottom)
            .disposed(by: disposeBag)
        
        let randomPhoto = viewModel.output.randomPhoto
            .observeOn(MainScheduler.instance)
            .share()
        
        randomPhoto
            .compactMap { $0.transform(width: "700", height: "700") }
            .bind(to: backgroundImage.kf.rx.image(options: [.transition(.fade(2.5))]))
            .disposed(by: disposeBag)
        
        randomPhoto
            .map { $0.user.name }
            .bind(to: remark.rx.animatedText(duration: 3.0, options: .transitionCrossDissolve))
            .disposed(by: disposeBag)
        
        viewModel.output.latestPhotos
            .observeOn(MainScheduler.instance)
            .bind(to: latestPhotos)
            .disposed(by: disposeBag)
        
        latestPhotos
            .bind(to:
                    collectionView.rx.items(cellIdentifier: "MainViewController", cellType: ShotCollectionViewCell.self)) { row, photo, cell in
                cell.configure(with: photo)
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo  = latestPhotos.value[indexPath.row]
        let height = CGFloat(photo.height * Int(Screen.width) / photo.width)
        let size   = CGSize(width: Screen.width, height: height)
        return size
    }
}
