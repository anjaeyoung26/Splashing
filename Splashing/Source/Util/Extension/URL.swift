//
//  URL.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/02.
//  Copyright © 2020 안재영. All rights reserved.
//

import SafariServices
import UIKit

extension URL {
    func value(for query: String) -> String? {
        guard let component = URLComponents(string: absoluteString) else { return nil }
        
        if let items = component.queryItems {
            for item in items where item.name == query {
                return item.value
            }
        }
        return nil
    }
    
    func open(presenter: UIViewController) {
        guard UIApplication.shared.canOpenURL(self) else { return }
        
        let safariViewControlller = SFSafariViewController(url: self)
        
        presenter.present(safariViewControlller, animated: true, completion: nil)
    }
}
