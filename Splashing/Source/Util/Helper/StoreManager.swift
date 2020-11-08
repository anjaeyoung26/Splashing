//
//  StoreManager.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/14.
//  Copyright © 2020 안재영. All rights reserved.
//
//  Request review code from https://www.raywenderlich.com/9009-requesting-app-ratings-and-reviews-tutorial-for-ios

import UIKit
import StoreKit

class StoreManager {
  
  static let sharedInstance = StoreManager()
  
  private let minimumReviewWorthyActionCount = 3

  func requestReviewIfAppropriate() {
    let defaults = UserDefaults.standard
    let bundle   = Bundle.main

    var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
    actionCount += 1
    defaults.set(actionCount, forKey: .reviewWorthyActionCount)

    guard actionCount >= minimumReviewWorthyActionCount else {
      return
    }
    // Read the current bundle version and the last bundle version used during the last prompt(if any).
    let bundleVersionKey = kCFBundleVersionKey as String
    let currentVersion   = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
    let lastVersion      = defaults.string(forKey: .lastReviewRequestAppVersion)
    // Check if this is the first request for this version of the app before continuing.
    guard lastVersion == nil || lastVersion != currentVersion else {
      return
    }

    SKStoreReviewController.requestReview()
    // Reset the action count and store the current version in UserDefaults so that you don't request againg on this version of the app.
    // 어플리케이션의 버전(Identity - Build)마다 한 번씩만 요청하도록 설정한다. 즉, 사용자가 특정 행위를 3번 이상 할 경우 현재 버전에서 최초로 한 번만 리뷰를 요청한다.
    defaults.set(0, forKey: .reviewWorthyActionCount)
    defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
  }

  func writeReview() {
    let unsplashAppStoreID = "1290631746"
    let urlString          = "itms-apps://itunes.apple.com/us/app/app-store/id" + unsplashAppStoreID
    let url                = URL(string: urlString)!
    
    var components   = URLComponents(url: url, resolvingAgainstBaseURL: false)
    
    components?.queryItems = [
      URLQueryItem(name: "mt",     value: "8"),
      URLQueryItem(name: "action", value: "write-review")
    ]
    //https://stackoverflow.com/questions/1781427/what-is-mt-8-in-itunes-links-for-the-app-store
    //URLQueryItem 중 mt의 의미 참고
    
    guard let writeReviewURL = components?.url,
      UIApplication.shared.canOpenURL(writeReviewURL) else { return }
    
    UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
  }
}
