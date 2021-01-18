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
    func fetchMe() -> Single<Void>
    
    var currentUser: Observable<User?> { get }
}

class UserService: BaseService, UserServiceType {
    let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)
    
    func fetchMe() -> Single<Void> {
        let keychain = Keychain(service: "com.splashing.ios")
        guard let accessToken = try? keychain.get("access_token") else { return .error(RxError.noElements) }
        
        return self.networking.request(.me(accessToken: accessToken))
            .mapJSON(User.self)
            .do(onSuccess: { [weak self] user in
                guard let weakSelf = self else { return }
                weakSelf.userSubject.onNext(user)
            })
            .map { _ in }
    }
}
