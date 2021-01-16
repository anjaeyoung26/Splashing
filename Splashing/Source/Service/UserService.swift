//
//  UserService.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/01.
//  Copyright © 2020 안재영. All rights reserved.
//

import KeychainAccess
import RxSwift

protocol UserServiceType {
    func fetch() -> Single<Void>
    
    var currentUser: Observable<User?> { get }
}

class UserService: BaseService, UserServiceType {
    let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)
    
    func fetch() -> Single<Void> {
        let keychain    = Keychain(service: "com.splashing.ios")
        let accessToken = try? keychain.get("access_token")
        return self.networking.request(.me(accessToken: accessToken ?? ""))
            .mapJSON(User.self)
            .do(onSuccess: { [weak self] user in
                guard let `self` = self else { return }
                self.userSubject.onNext(user)
            })
            .map { _ in }
    }
}
