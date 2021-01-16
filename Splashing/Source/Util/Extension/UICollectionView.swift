//
//  UICollectionView.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/02.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

extension UICollectionView {
    func setBackgroundView(image: UIImage, message: String) {
        let imageView    = UIImageView().then {
            $0.contentMode   = .scaleAspectFit
            $0.tintColor     = .darkGray
            $0.image         = image
        }
        
        let lblMessage   = UILabel().then {
            $0.font          = UIFont.systemFont(ofSize: 20)
            $0.textColor     = .white
            $0.textAlignment = .center
            $0.text          = message
        }
        
        let backgroundView = UIView().then {
            $0.addSubview(imageView)
            $0.addSubview(lblMessage)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(180)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-60)
        }
        
        lblMessage.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        self.backgroundView = backgroundView
    }
    
    func unsetBackgroundView() {
        self.backgroundView = nil
    }
}
