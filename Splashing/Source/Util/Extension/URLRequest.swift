//
//  URLRequest.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/05.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

extension URLRequest {
    static func build(with request: API.Request) -> URLRequest? {
        guard var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: false) else { return nil }
        
        if let parameters = request.parameter {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.allHTTPHeaderFields = request.header
        urlRequest.httpMethod          = request.method
        
        return urlRequest
    }
}
