//
//  PHPhotoLibrary.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/09.
//  Copyright © 2020 안재영. All rights reserved.
//

import Photos
import RxSwift
import UIKit

extension PHPhotoLibrary {
  private func assetChangeRequest(from image: UIImage, _ completion: @escaping (Bool) -> ()) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }, completionHandler: { result, _ in
      completion(result)
    })
  }
  
  func save(image: UIImage) -> Observable<Bool> {
    return Observable.create { observer in
      if PHPhotoLibrary.authorizationStatus() == .authorized {
        self.assetChangeRequest(from: image) { result in
          observer.onNext(result)
          observer.onCompleted()
        }
      } else {
        PHPhotoLibrary.requestAuthorization { status in
          switch status {
          case .authorized:
            self.assetChangeRequest(from: image) { result in
              observer.onNext(result)
            }
          default:
            observer.onNext(false)
          }
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}
