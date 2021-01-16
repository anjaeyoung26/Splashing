//
//  Font.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/31.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

enum Font {
    enum Helvetica {
        static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Bold",   size: size)!
        }
        static func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Medium", size: size)!
        }
    }
}
