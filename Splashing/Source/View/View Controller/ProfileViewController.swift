//
//  ProfileViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/02.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: BaseViewController {
    
    enum Height {
        static let image = 80
        static let name  = 30
    }
    
    enum Radius {
        static let image: CGFloat = 40
    }
    
    let backButton = UIButton().then {
        $0.setImage(SFSymbol.back, for: .normal)
        $0.tintColor = .white
    }
    
    let logoutButton = UIButton().then {
        $0.setImage(Icon.logout, for: .normal)
    }
    
    let image = UIImageView().then {
        $0.layer.cornerRadius = Radius.image
        $0.clipsToBounds      = true
    }
    
    let name = UILabel().then {
        $0.font      = Font.Helvetica.bold(size: 25)
        $0.textColor = .white
    }
    
    let segmentedControl = UISegmentedControl(items: ["Photos", "Likes"]).then {
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        $0.selectedSegmentIndex     = 0
        $0.selectedSegmentTintColor = Color.mediumGray
        $0.backgroundColor = Color.charcoal
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.register(ShotCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileViewController")
    }
    
    let flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing      = 0
    }
    
    let receivedPhotos = BehaviorRelay<[Photo]>(value: [])
    
    let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
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
    
    override func addSubview() {
        [backButton, logoutButton, image, name, segmentedControl, collectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        backButton.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        image.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Height.image)
        }
        
        name.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(image.snp.bottom).offset(30)
            $0.height.equalTo(Height.name)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(30)
            $0.left.right.equalTo(view.readableContentGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(30)
            $0.width.bottom.equalToSuperview()
        }
    }
    
    override func binding() {
        self.rx.viewDidAppear
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .bind(to: viewModel.input.segmentIndex)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(to: viewModel.input.logoutButtonTapped)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { self.receivedPhotos.value[$0.row] }
            .bind(to: viewModel.input.photoSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.completeLogout
            .subscribe(onNext: {
                if let presentingViewController = self.presentingViewController {
                    self.dismiss(animated: true, completion: {
                        presentingViewController.dismiss(animated: true, completion: nil)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        receivedPhotos
            .observeOn(MainScheduler.instance)
            .bind(to:
                    collectionView.rx.items(cellIdentifier: "ProfileViewController", cellType: ShotCollectionViewCell.self)) { row, photo, cell in
                cell.configure(with: photo)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.currentUser
            .observeOn(MainScheduler.instance)
            .filterNil()
            .subscribe(onNext: {
                self.presentCurrentUser(with: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.photos
            .observeOn(MainScheduler.instance)
            .catchOnEmpty {
                self.collectionView.setBackgroundView(image: Icon.empty!, message: "No photos")
                return .just([])
            }
            .bind(to: receivedPhotos)
            .disposed(by: disposeBag)
    }
    
    func presentCurrentUser(with user: User) {
        let urlString = user.images.small
        let url       = URL(string: urlString)
        self.image.kf.setImage(with: url)
        self.name.text = user.name
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo  = receivedPhotos.value[indexPath.row]
        let height = CGFloat(photo.height * Int(Screen.width) / photo.width)
        let size   = CGSize(width: Screen.width, height: height)
        return size
    }
}
