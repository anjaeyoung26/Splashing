//
//  BaseCollectionViewCell.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/31.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview()
    setConstraint()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func addSubview() {
    
  }
  
  func setConstraint() {
    
  }
}
