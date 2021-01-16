//
//  ShotCollectionViewCell.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/31.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

class ShotCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView().then {
        $0.contentMode   = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let remark = UILabel().then {
        $0.font      = Font.Helvetica.medium(size: 15)
        $0.textColor = .white
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        remark.text     = nil
    }
    
    override func addSubview() {
        self.addSubview(imageView)
        self.addSubview(remark)
    }
    
    override func setConstraint() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        remark.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalTo(imageView.snp.bottom).offset(-10)
        }
    }
    
    func configure(with photo: Photo) {
        let urlString = photo.urls.small
        let url = URL(string: urlString)
        
        imageView.kf.setImage(with: url)
        
        remark.text = photo.user.name
    }
}
