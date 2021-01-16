//
//  ShareManager.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/15.
//  Copyright © 2020 안재영. All rights reserved.
//

import UIKit

class ShareManager {
    
    static let sharedInstance = ShareManager()
    
    func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType],
        from viewController: UIViewController)
    {
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        activityViewController.excludedActivityTypes      = excludedActivityTypes
        activityViewController.completionWithItemsHandler = { type, result, item, error in
            if !result || error != nil {
                Toaster.show(message: "Fail to share content", delay: 3.0, completion: nil)
            }
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
