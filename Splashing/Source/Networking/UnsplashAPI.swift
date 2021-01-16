//
//  UnsplashAPI.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

import Foundation

enum API {
    static let accessKey = Bundle.main.accessKey
    static let secretKey = Bundle.main.secretKey
    static let baseURL = "https://api.unsplash.com"
    static let authorizeURL = "https://unsplash.com/oauth/authorize"
    static let accessTokenURL = "https://unsplash.com/oauth/token"
}

extension API {
    enum Request {
        case url(URL)
        case me(accessToken: String)
        case latest
        case random
        case search(query: String)
        case downloadLink(id: String)
        case users(name: String)
        case liked(name: String)
    }
}

extension API.Request {
    var url: URL {
        switch self {
        case .url(let url):
            return url
        default:
            return URL(string: API.baseURL + path)!
        }
    }
    
    var path: String {
        switch self {
        case .url: return ""
        case .me: return "/me"
        case .latest: return "/photos"
        case .random: return "/photos/random"
        case .search: return "/search/photos"
        case .downloadLink(let id) : return "/photos/" + id + "/download"
        case .users(let name): return "/users/" + name + "/photos"
        case .liked(let name): return "/users/" + name + "/likes"
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .me(let accessToken):
            return [
                "Authorization" : "Bearer " + accessToken
            ]
        default:
            return nil
        }
    }
    
    var parameter: [String: String]? {
        switch self {
        case .url:
            return nil
            
        case .random:
            return [
                "client_id" : API.accessKey,
                "count"     : "3"
            ]
            
        case .search(let query):
            return [
                "client_id" : API.accessKey,
                "query"     : query
            ]
            
        default:
            return [
                "client_id" : API.accessKey,
            ]
        }
    }
}
