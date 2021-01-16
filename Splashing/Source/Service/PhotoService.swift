//
//  PhotoService.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/05.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift
import UIKit

protocol PhotoServiceType {
    func url(_ url: URL)          -> Single<List<Photo>>
    func latest()                 -> Single<List<Photo>>
    func random()                 -> Single<[Photo]>
    func users(name: String)      -> Single<[Photo]>
    func liked(name: String)      -> Single<[Photo]>
    func search(query: String)    -> Single<[Photo]>
    func downloadLink(id: String) -> Single<Link>
}

class PhotoService: BaseService, PhotoServiceType {
    func url(_ url: URL) -> Single<List<Photo>> {
        return self.networking.request(.url(url))
            .mapJSON(List<Photo>.self)
            .catchErrorJustReturn(List<Photo>(item: []))
    }
    
    func latest() -> Single<List<Photo>> {
        return self.networking.request(.latest)
            .mapJSON(List<Photo>.self)
            .catchErrorJustReturn(List<Photo>(item: []))
    }
    
    func random() -> Single<[Photo]> {
        return self.networking.request(.random)
            .mapJSON([Photo].self)
            .catchErrorJustReturn([])
    }
    
    func users(name: String) -> Single<[Photo]> {
        return self.networking.request(.users(name: name))
            .mapJSON([Photo].self)
            .catchErrorJustReturn([])
    }
    
    func liked(name: String) -> Single<[Photo]> {
        return self.networking.request(.liked(name: name))
            .mapJSON([Photo].self)
            .catchErrorJustReturn([])
    }
    
    func search(query: String) -> Single<[Photo]> {
        return self.networking.request(.search(query: query))
            .mapJSON(Result.self)
            .map { $0.results }
            .catchErrorJustReturn([])
    }
    
    func downloadLink(id: String) -> Single<Link> {
        return self.networking.request(.downloadLink(id: id))
            .mapJSON(Link.self)
    }
}
