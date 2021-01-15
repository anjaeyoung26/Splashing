//
//  BaseService.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/15.
//  Copyright © 2021 안재영. All rights reserved.
//

class BaseService {
    unowned let provider: ServiceProviderType
    
    let networking: NetworkingProtocol
    
    init(provider: ServiceProviderType, networking: NetworkingProtocol) {
        self.provider = provider
        self.networking = networking
    }
}
