//
//  ServiceProvider.swift
//  Splashing
//
//  Created by 안재영 on 2021/01/15.
//  Copyright © 2021 안재영. All rights reserved.
//

protocol ServiceProviderType: class {
    var networking: NetworkingProtocol { get }
    var authService: AuthServiceType { get }
    var userService: UserServiceType { get }
    var photoService: PhotoServiceType { get }
}

class ServiceProvider: ServiceProviderType {
    lazy var networking: NetworkingProtocol = Networking()
    lazy var authService: AuthServiceType = AuthService(provider: self, networking: networking)
    lazy var userService: UserServiceType = UserService(provider: self, networking: networking)
    lazy var photoService: PhotoServiceType = PhotoService(provider: self, networking: networking)
}
