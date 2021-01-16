//
//  Networking.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift

protocol NetworkingProtocol {
    func request( _ request: API.Request, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension NetworkingProtocol {
    func request( _ request: API.Request, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
        return self.request(request, file: file, function: function, line: line)
    }
}

class Networking: NetworkingProtocol {
    func request(
        _ request: API.Request,
        file: StaticString     = #file,
        function: StaticString = #function,
        line: UInt             = #line)
    -> Single<Response> {
        guard let urlRequest = URLRequest.build(with: request) else { return .never() }
        
        let session       = URLSession.shared
        let requestString = "\(request.method) \(request.path)"
        
        return session.rx.request(with: urlRequest)
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
                },
                onError: { error in
                    let message = "FAILURE: \(requestString) \(error.localizedDescription)"
                    log.warning(message, file: file, function: function, line: line)
                },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
                })
    }
}
