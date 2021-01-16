//
//  UILabel+Rx.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/26.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    func animatedText(duration: TimeInterval, options: UIView.AnimationOptions, completion: ((Bool) -> Void)? = nil) -> Binder<String> {
        return Binder(self.base) { label, text in
            let animations: (() -> Void) = {
                label.text = text
            }
            UIView.transition(with: label, duration: duration, options: options, animations: animations, completion: completion)
        }
    }
}
