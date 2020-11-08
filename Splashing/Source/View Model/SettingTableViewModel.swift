//
//  SettingTableViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/02.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation
import UIKit

class SettingTableViewModel: NSObject {
  
  enum Height {
    static let footer: CGFloat = 1
    static let row:    CGFloat = 60
  }
  
  enum Count {
    static let section = 2
  }
  
  let firstSectionItems  = ["Recommend", "Write a review"]
  let secondSectionItems = ["Visit Unsplash.com", "License"]
  
  let viewController: UIViewController
  
  init(viewController: UIViewController) {
    self.viewController = viewController
  }
}

extension SettingTableViewModel: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return firstSectionItems.count
    case 1: return secondSectionItems.count
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewController", for: indexPath)
    
    switch indexPath.section {
    case 0: cell.textLabel?.text = self.firstSectionItems[indexPath.row]
    case 1: cell.textLabel?.text = self.secondSectionItems[indexPath.row]
    default: break
    }

    cell.textLabel?.font      = UIFont.systemFont(ofSize: 17)
    cell.textLabel?.textColor = .white

    cell.backgroundColor      = .black
    cell.selectionStyle       = .none
    
    return cell
  }
}

extension SettingTableViewModel: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Count.section
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Height.row
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return Height.footer
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView().then {
      $0.backgroundColor = .lightGray
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      
      switch indexPath.row {
      case 0:
        let unsplashAppStoreID = "1290631746"
        let urlString          = "https://apps.apple.com/app/apple-store/id" + unsplashAppStoreID
        let url                = URL(string: urlString)!
        let text = "Unsplash is a great app with beautiful images and wallpapers, check it out on the App Store."
        
        ShareManager.sharedInstance.share(
          items: [text, url],
          excludedActivityTypes: [.print, .copyToPasteboard],
          from: self.viewController)
      case 1:
        StoreManager.sharedInstance.writeReview()
      default: break
      }
      
    case 1:
      
      switch indexPath.row {
      case 0:
        let url = URL(string: "http://unsplash.com")!
        url.open(presenter: self.viewController)
      case 1:
        let url = URL(string: "http://unsplash.com/license")!
        url.open(presenter: self.viewController)
      default: break
      }
      
    default: break
    }
  }
}
