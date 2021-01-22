//
//  DetailViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/03.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import Toaster
import UIKit

class DetailViewController: BaseViewController {
    
    enum Height {
        static let photoImage     = Screen.height / 3
        static let downloadButton = 30
        static let backButton     = 30
        static let name           = 30
        static let description    = 50
        static let heart          = 20
        static let likes          = 30
    }
    
    enum Radius {
        static let profileImage: CGFloat = 13
    }
    
    let scrollView = UIScrollView(frame: Screen.frame).then {
        $0.bounces = false
    }
    
    let photoImage = UIImageView()
    
    let backButton = UIButton().then {
        $0.setImage(SFSymbol.back, for: .normal)
        $0.tintColor = .white
    }
    
    let downloadButton = UIButton().then {
        $0.setImage(SFSymbol.download(size: 20), for: .normal)
        $0.tintColor = .white
    }
    
    let name = UILabel().then {
        $0.font = Font.Helvetica.medium(size: 20)
        $0.textColor = .white
    }
    
    let descriptions = UILabel().then {
        $0.textColor     = .white
        $0.numberOfLines = 0
    }
    
    let heart = UIImageView().then {
        $0.image     = SFSymbol.heart
        $0.tintColor = .white
    }
    
    let likes = UILabel().then {
        $0.font      = Font.Helvetica.medium(size: 18)
        $0.textColor = .white
    }
    
    let viewModel: DetailViewModel
    
    var photo: Photo?
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView(about: photo!)
        configurePhotoImageView(with: photo!)
    }
    
    override func addSubview() {
        [backButton, downloadButton, name, photoImage, heart, likes, descriptions].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
    }
    
    override func setConstraints() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(scrollView.readableContentGuide).offset(10)
            $0.height.equalTo(Height.backButton)
        }
        
        downloadButton.snp.makeConstraints {
            $0.top.equalTo(backButton)
            $0.right.equalTo(scrollView.readableContentGuide).offset(-10)
            $0.height.equalTo(Height.downloadButton)
        }
        
        name.snp.makeConstraints {
            $0.top.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Height.name)
        }
        
        photoImage.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.equalTo(name.snp.bottom).offset(30)
            $0.height.greaterThanOrEqualTo(Height.photoImage)
        }
        
        heart.snp.makeConstraints {
            $0.top.equalTo(photoImage.snp.bottom).offset(20)
            $0.left.equalTo(scrollView.snp.left).offset(30)
            $0.width.height.equalTo(Height.heart)
        }
        
        likes.snp.makeConstraints {
            $0.top.equalTo(heart).offset(-5)
            $0.left.equalTo(heart.snp.right).offset(15)
            $0.height.equalTo(Height.likes)
        }
        
        descriptions.snp.makeConstraints {
            $0.top.equalTo(heart.snp.bottom).offset(20)
            $0.left.right.equalTo(view.readableContentGuide)
            $0.height.greaterThanOrEqualTo(Height.description)
            $0.bottom.equalToSuperview().offset(-80)
        }
    }
    
    override func binding() {
        self.rx.viewDidAppear
            .compactMap { self.photo }
            .bind(to: viewModel.input.currentPhoto)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        downloadButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.downloadButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.downloadResult
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    Toaster.show(
                        message: "Success to save photo",
                        delay: Delay.short,
                        completion: {
                            StoreManager.sharedInstance.requestReviewIfAppropriate()
                        })
                } else {
                    Toaster.show(
                        message: "Fail to save photo",
                        delay: Delay.short,
                        completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configureView(about photo: Photo) {
        guard let photoURL = URL(string: photo.urls.small) else { return }
        
        self.photoImage.kf.setImage(with: photoURL)
        
        self.descriptions.text = photo.description ?? ""
        self.likes.text        = String(photo.likes)
        self.name.text         = photo.user.name
    }
    
    func configurePhotoImageView(with photo: Photo) {
        let height = CGFloat(photo.height * Int(Screen.width) / photo.width)
        let size   = CGSize(width: Screen.width, height: height)
        self.photoImage.frame = CGRect(origin: .zero, size: size)
    }
}
