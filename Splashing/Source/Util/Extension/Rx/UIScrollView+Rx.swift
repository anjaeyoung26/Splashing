//
//  UIScrollView+Rx.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/21.
//  Copyright © 2021 안재영. All rights reserved.
//

// Source : http://minsone.github.io/mac/ios/how-to-make-similar-twitter-cover-in-swift

import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    func parallex(with view: UIView) -> Binder<Void> {
        return Binder(self.base) { scrollView, _ in
            let yPos = scrollView.contentOffset.y
            
            if yPos < 0 {
                let scale = 1 + ((-yPos) * 5 / view.frame.height)
                view.transform = CGAffineTransform.identity
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
                
                var viewFrame = view.frame
                viewFrame.origin.y = yPos
                view.frame = viewFrame
            }
        }
    }
}
