//
//  URLSession+Rx.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/05.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift

extension Reactive where Base: URLSession {
    func request(with request: URLRequest) -> Single<Response> {
        return Single.create { [weak base] single in
            let dataTask = base?.dataTask(with: request) { data, response, error in
                if let data = data {
                    let response = Response(data: data, response: response as! HTTPURLResponse)
                    single(.success(response))
                } else if let error = error {
                    single(.error(error))
                }
            }
            dataTask?.resume()
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}
