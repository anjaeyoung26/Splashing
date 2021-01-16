//
//  SearchViewController.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/09.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SearchViewController: BaseViewController {
    
    enum Height {
        static let searchBar = 50
    }
    
    enum Frame {
        static let searchBar = CGRect(x: 0, y: 0, width: Int(Screen.width), height: Height.searchBar)
    }
    
    let searchBar = UISearchBar(frame: Frame.searchBar).then {
        $0.searchTextField.leftView?.tintColor = .white
        $0.searchTextField.textColor           = .white
        $0.tintColor                           = .white
        $0.backgroundColor                     = Color.charcoal
        $0.showsCancelButton                   = true
        $0.searchBarStyle                      = .minimal
        $0.barStyle = .black
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.register(ShotCollectionViewCell.self, forCellWithReuseIdentifier: "SearchViewController")
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    let flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing      = 0
    }
    
    let receivedPhotos = BehaviorRelay<[Photo]>(value: [])
    
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.charcoal
        collectionView.collectionViewLayout = flowLayout
        
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func addSubview() {
        [searchBar, collectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.readableContentGuide)
            $0.width.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func binding() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { self.receivedPhotos.value[$0.row] }
            .bind(to: viewModel.input.photoSelected)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .bind(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(to: viewModel.input.searchButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.searchResult
            .bind(to: receivedPhotos)
            .disposed(by: disposeBag)
        
        receivedPhotos
            .observeOn(MainScheduler.instance)
            .bind(to:
                    collectionView.rx.items(cellIdentifier: "SearchViewController", cellType: ShotCollectionViewCell.self)) { row, photo, cell in
                cell.configure(with: photo)
            }
            .disposed(by: disposeBag)
    }
}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo  = receivedPhotos.value[indexPath.row]
        let height = CGFloat(photo.height * Int(Screen.width) / photo.width)
        let size   = CGSize(width: Screen.width, height: height)
        return size
    }
}
