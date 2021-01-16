//
//  Toaster.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/12.
//  Copyright © 2020 안재영. All rights reserved.
//

import Toaster

class Toaster {
    static func show(message: String, delay: TimeInterval, completion: (() -> ())?) {
        let toast                  = Toast(text: message, duration: delay)
        toast.view.font            = Font.Helvetica.medium(size: 16)
        toast.view.backgroundColor = Color.charcoal
        toast.view.textColor       = .white
        toast.completionBlock      = completion
        toast.show()
    }
}
