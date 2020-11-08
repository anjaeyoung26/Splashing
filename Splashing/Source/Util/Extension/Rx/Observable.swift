//
//  Observable.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/22.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift

extension ObservableType where Element == Bool {
  func filterTrue() -> Observable<Element> {
    return self.flatMap { element -> Observable<Element> in
      if element {
        return Observable<Element>.just(element)
      } else {
        return Observable<Element>.empty()
      }
    }
  }
}

extension ObservableType {
  func merge(with object: Observable<Element>) -> Observable<Element> {
    return Observable.merge(self.asObservable(), object)
  }
}
